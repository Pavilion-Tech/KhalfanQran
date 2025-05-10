import 'package:flutter/material.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/models/student_model.dart';

class ManageStudents extends StatefulWidget {
  final FirebaseService? firebaseService;

  const ManageStudents({
    Key? key,
    required this.firebaseService,
  }) : super(key: key);

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  bool _isLoading = false;
  List<StudentModel> _students = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For now, we'll use sample data
      // In full implementation, fetch from Firebase
      await Future.delayed(const Duration(seconds: 1));
      
      final List<StudentModel> sampleStudents = [
        StudentModel(
          id: '1',
          name: 'أحمد محمد',
          dateOfBirth: DateTime(2010, 5, 15),
          gender: StudentGender.male,
          parentId: 'parent1',
          grade: 'الصف الخامس',
          level: 2,
          memorizedSurahs: ['1', '112', '113', '114'],
          joinDate: DateTime(2022, 9, 1),
        ),
        StudentModel(
          id: '2',
          name: 'فاطمة علي',
          dateOfBirth: DateTime(2011, 7, 22),
          gender: StudentGender.female,
          parentId: 'parent2',
          grade: 'الصف الرابع',
          level: 1,
          memorizedSurahs: ['1', '112'],
          joinDate: DateTime(2023, 1, 15),
        ),
        StudentModel(
          id: '3',
          name: 'محمد خالد',
          dateOfBirth: DateTime(2009, 3, 10),
          gender: StudentGender.male,
          parentId: 'parent3',
          grade: 'الصف السادس',
          level: 3,
          memorizedSurahs: ['1', '112', '113', '114', '2'],
          joinDate: DateTime(2021, 10, 5),
        ),
      ];
      
      setState(() {
        _students = sampleStudents;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading students: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تحميل بيانات الطلاب: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<StudentModel> get _filteredStudents {
    if (_searchQuery.isEmpty) {
      return _students;
    }
    return _students
        .where((student) =>
            student.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلاب'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'بحث عن طالب',
                hintText: 'ادخل اسم الطالب للبحث',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Student list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredStudents.isEmpty
                    ? const Center(
                        child: Text(
                          'لا يوجد طلاب للعرض',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = _filteredStudents[index];
                          return _buildStudentCard(student);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditStudentDialog(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'إضافة طالب جديد',
      ),
    );
  }

  Widget _buildStudentCard(StudentModel student) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  child: Text(
                    student.name.characters.first,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        student.grade,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildLevelBadge(student.level),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'تاريخ الانضمام: ${_formatDate(student.joinDate)}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.menu_book,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'السور المحفوظة: ${student.memorizedSurahs.length}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    _showStudentDetailsDialog(context, student);
                  },
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('عرض التفاصيل'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _showAddEditStudentDialog(context, student: student);
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('تعديل'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, student);
                  },
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text(
                    'حذف',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelBadge(int level) {
    Color badgeColor;
    String levelText;

    switch (level) {
      case 1:
        badgeColor = Colors.green;
        levelText = 'مبتدئ';
        break;
      case 2:
        badgeColor = Colors.blue;
        levelText = 'متوسط';
        break;
      case 3:
        badgeColor = Colors.purple;
        levelText = 'متقدم';
        break;
      default:
        badgeColor = Colors.grey;
        levelText = 'غير محدد';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        levelText,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showStudentDetailsDialog(BuildContext context, StudentModel student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('الصف الدراسي', student.grade),
              _buildDetailItem('تاريخ الميلاد', _formatDate(student.dateOfBirth)),
              _buildDetailItem(
                'الجنس',
                student.gender == StudentGender.male ? 'ذكر' : 'أنثى',
              ),
              _buildDetailItem('تاريخ الانضمام', _formatDate(student.joinDate)),
              _buildDetailItem('المستوى', _getLevelText(student.level)),
              _buildDetailItem(
                'السور المحفوظة',
                '${student.memorizedSurahs.length} سورة',
              ),
              const SizedBox(height: 10),
              const Text(
                'السور المحفوظة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: student.memorizedSurahs
                    .map(
                      (surah) => Chip(
                        label: Text(_getSurahName(surah)),
                        backgroundColor: Colors.green.shade100,
                        labelStyle: TextStyle(color: Colors.green.shade800),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showAddEditStudentDialog(BuildContext context, {StudentModel? student}) {
    final isEditing = student != null;
    final nameController = TextEditingController(text: isEditing ? student.name : '');
    final gradeController = TextEditingController(text: isEditing ? student.grade : '');
    
    StudentGender selectedGender = isEditing ? student.gender : StudentGender.male;
    DateTime selectedBirthDate = isEditing ? student.dateOfBirth : DateTime(2010, 1, 1);
    int selectedLevel = isEditing ? student.level : 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'تعديل بيانات الطالب' : 'إضافة طالب جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الطالب',
                    hintText: 'ادخل اسم الطالب',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: gradeController,
                  decoration: const InputDecoration(
                    labelText: 'الصف الدراسي',
                    hintText: 'ادخل الصف الدراسي',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('الجنس:'),
                    const SizedBox(width: 16),
                    Radio<StudentGender>(
                      value: StudentGender.male,
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                    const Text('ذكر'),
                    const SizedBox(width: 16),
                    Radio<StudentGender>(
                      value: StudentGender.female,
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                    const Text('أنثى'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('تاريخ الميلاد:'),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedBirthDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            selectedBirthDate = date;
                          });
                        }
                      },
                      child: Text(_formatDate(selectedBirthDate)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('المستوى:'),
                    const SizedBox(width: 16),
                    DropdownButton<int>(
                      value: selectedLevel,
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: const Text('مبتدئ'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: const Text('متوسط'),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: const Text('متقدم'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedLevel = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                // In full implementation, save to Firebase
                if (nameController.text.isEmpty || gradeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى ملء جميع الحقول المطلوبة'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (isEditing) {
                  // Update existing student
                  final updatedStudent = student.copyWith(
                    name: nameController.text,
                    grade: gradeController.text,
                    gender: selectedGender,
                    dateOfBirth: selectedBirthDate,
                    level: selectedLevel,
                  );
                  
                  setState(() {
                    final index = _students.indexWhere((s) => s.id == student.id);
                    if (index != -1) {
                      _students[index] = updatedStudent;
                    }
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تحديث بيانات الطالب بنجاح'),
                    ),
                  );
                } else {
                  // Add new student
                  final newStudent = StudentModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    dateOfBirth: selectedBirthDate,
                    gender: selectedGender,
                    parentId: 'parent_id', // This would come from Firebase Auth in full implementation
                    grade: gradeController.text,
                    level: selectedLevel,
                    memorizedSurahs: [],
                    joinDate: DateTime.now(),
                  );
                  
                  setState(() {
                    _students.add(newStudent);
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إضافة الطالب بنجاح'),
                    ),
                  );
                }
                
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'تحديث' : 'إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, StudentModel student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الطالب ${student.name}؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // In full implementation, delete from Firebase
              setState(() {
                _students.removeWhere((s) => s.id == student.id);
              });
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف الطالب بنجاح'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getLevelText(int level) {
    switch (level) {
      case 1:
        return 'مبتدئ';
      case 2:
        return 'متوسط';
      case 3:
        return 'متقدم';
      default:
        return 'غير محدد';
    }
  }

  String _getSurahName(String surahId) {
    // In full implementation, fetch from Quran database
    final Map<String, String> surahNames = {
      '1': 'الفاتحة',
      '2': 'البقرة',
      '112': 'الإخلاص',
      '113': 'الفلق',
      '114': 'الناس',
    };
    
    return surahNames[surahId] ?? 'سورة $surahId';
  }
}