import 'package:flutter/material.dart';
import 'package:khalfan_center/models/student_model.dart';
import 'package:khalfan_center/models/user_model.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:intl/intl.dart';

class StudentForm extends StatefulWidget {
  final FirebaseService firebaseService;
  final StudentModel? student;
  final Function(StudentModel)? onStudentAdded;
  final Function(StudentModel)? onStudentUpdated;

  const StudentForm({
    Key? key,
    required this.firebaseService,
    this.student,
    this.onStudentAdded,
    this.onStudentUpdated,
  }) : super(key: key);

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  
  DateTime _selectedDateOfBirth = DateTime(2010, 1, 1);
  DateTime _selectedJoinDate = DateTime.now();
  StudentGender _selectedGender = StudentGender.male;
  int _selectedLevel = 1;
  
  List<UserModel> _parents = [];
  String? _selectedParentId;
  
  List<String> _memorizedSurahs = [];
  final List<String> _availableSurahs = List.generate(114, (index) => (index + 1).toString());
  
  bool _isLoading = false;
  bool _isSubmitting = false;
  String _errorMessage = '';
  bool _isEditMode = false;
  
  @override
  void initState() {
    super.initState();
    _isEditMode = widget.student != null;
    
    _loadParents();
    
    if (_isEditMode) {
      _nameController.text = widget.student!.name;
      _gradeController.text = widget.student!.grade;
      _selectedDateOfBirth = widget.student!.dateOfBirth;
      _selectedJoinDate = widget.student!.joinDate;
      _selectedGender = widget.student!.gender;
      _selectedLevel = widget.student!.level;
      _selectedParentId = widget.student!.parentId;
      _memorizedSurahs = List.from(widget.student!.memorizedSurahs);
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }
  
  Future<void> _loadParents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final parents = await widget.firebaseService.getUsersByRole(UserRole.parent);
      setState(() {
        _parents = parents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تحميل بيانات أولياء الأمور: $e';
        _isLoading = false;
      });
    }
  }
  
  Future<void> _selectDate(BuildContext context, bool isDateOfBirth) async {
    final DateTime initialDate = isDateOfBirth ? _selectedDateOfBirth : _selectedJoinDate;
    final DateTime firstDate = isDateOfBirth 
        ? DateTime(2000) 
        : DateTime(2020);
    final DateTime lastDate = isDateOfBirth 
        ? DateTime.now().subtract(const Duration(days: 365 * 3)) // At least 3 years old
        : DateTime.now().add(const Duration(days: 30)); // Up to a month from now
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isDateOfBirth) {
          _selectedDateOfBirth = picked;
        } else {
          _selectedJoinDate = picked;
        }
      });
    }
  }
  
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedParentId == null) {
        setState(() {
          _errorMessage = 'الرجاء اختيار ولي الأمر';
        });
        return;
      }
      
      setState(() {
        _isSubmitting = true;
        _errorMessage = '';
      });
      
      try {
        final StudentModel studentData = StudentModel(
          id: _isEditMode ? widget.student!.id : 'student_${DateTime.now().millisecondsSinceEpoch}',
          name: _nameController.text,
          dateOfBirth: _selectedDateOfBirth,
          gender: _selectedGender,
          parentId: _selectedParentId!,
          grade: _gradeController.text,
          level: _selectedLevel,
          memorizedSurahs: _memorizedSurahs,
          joinDate: _selectedJoinDate,
        );
        
        await widget.firebaseService.setStudentData(studentData);
        
        if (_isEditMode) {
          if (widget.onStudentUpdated != null) {
            widget.onStudentUpdated!(studentData);
          }
        } else {
          if (widget.onStudentAdded != null) {
            widget.onStudentAdded!(studentData);
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'حدث خطأ: $e';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }
  
  void _toggleSurah(String surahNumber) {
    setState(() {
      if (_memorizedSurahs.contains(surahNumber)) {
        _memorizedSurahs.remove(surahNumber);
      } else {
        _memorizedSurahs.add(surahNumber);
      }
      // Sort numerically
      _memorizedSurahs.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Container(
      width: double.maxFinite,
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditMode ? 'تعديل بيانات الطالب' : 'إضافة طالب جديد',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم الطالب',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال اسم الطالب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, true),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'تاريخ الميلاد',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(dateFormat.format(_selectedDateOfBirth)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, false),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'تاريخ الانضمام',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.date_range),
                              ),
                              child: Text(dateFormat.format(_selectedJoinDate)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'الجنس',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.people),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<StudentGender>(
                                value: _selectedGender,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(
                                    value: StudentGender.male,
                                    child: Text('ذكر'),
                                  ),
                                  DropdownMenuItem(
                                    value: StudentGender.female,
                                    child: Text('أنثى'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _gradeController,
                            decoration: const InputDecoration(
                              labelText: 'الصف الدراسي',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.school),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال الصف الدراسي';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'المستوى',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.grade),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _selectedLevel,
                                isExpanded: true,
                                items: List.generate(5, (index) {
                                  final level = index + 1;
                                  return DropdownMenuItem(
                                    value: level,
                                    child: Text('المستوى $level'),
                                  );
                                }),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedLevel = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'ولي الأمر',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.family_restroom),
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                : DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedParentId,
                                      isExpanded: true,
                                      hint: const Text('اختر ولي الأمر'),
                                      items: _parents.map((parent) {
                                        return DropdownMenuItem(
                                          value: parent.id,
                                          child: Text(parent.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedParentId = value;
                                        });
                                      },
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'السور المحفوظة:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableSurahs.map((surah) {
                        final isSelected = _memorizedSurahs.contains(surah);
                        return FilterChip(
                          label: Text(surah),
                          selected: isSelected,
                          onSelected: (_) => _toggleSurah(surah),
                          backgroundColor: Colors.grey[200],
                          selectedColor: Colors.blue[100],
                          checkmarkColor: Colors.blue[800],
                        );
                      }).toList(),
                    ),
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.red[50],
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                  child: const Text('إلغاء'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(_isEditMode ? 'تحديث' : 'إضافة'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}