import 'package:flutter/material.dart';
import 'package:khalfan_center/services/firebase_service.dart';

// تعريف نموذج بيانات الحلقة
class QuranClass {
  final String id;
  final String name;
  final String teacherId;
  final String teacherName;
  final List<String> days;
  final String time;
  final String location;
  final int maxStudents;
  final int currentStudents;
  final String level;
  final String status;

  QuranClass({
    required this.id,
    required this.name,
    required this.teacherId,
    required this.teacherName,
    required this.days,
    required this.time,
    required this.location,
    required this.maxStudents,
    required this.currentStudents,
    required this.level,
    required this.status,
  });

  QuranClass copyWith({
    String? id,
    String? name,
    String? teacherId,
    String? teacherName,
    List<String>? days,
    String? time,
    String? location,
    int? maxStudents,
    int? currentStudents,
    String? level,
    String? status,
  }) {
    return QuranClass(
      id: id ?? this.id,
      name: name ?? this.name,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      days: days ?? this.days,
      time: time ?? this.time,
      location: location ?? this.location,
      maxStudents: maxStudents ?? this.maxStudents,
      currentStudents: currentStudents ?? this.currentStudents,
      level: level ?? this.level,
      status: status ?? this.status,
    );
  }
}

class ManageClasses extends StatefulWidget {
  final FirebaseService? firebaseService;

  const ManageClasses({
    Key? key,
    required this.firebaseService,
  }) : super(key: key);

  @override
  State<ManageClasses> createState() => _ManageClassesState();
}

class _ManageClassesState extends State<ManageClasses> {
  bool _isLoading = false;
  List<QuranClass> _classes = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For now, we'll use sample data
      // In full implementation, fetch from Firebase
      await Future.delayed(const Duration(seconds: 1));
      
      final List<QuranClass> sampleClasses = [
        QuranClass(
          id: 'class1',
          name: 'حلقة حفظ القرآن للمبتدئين',
          teacherId: 'teacher1',
          teacherName: 'عبدالله محمد',
          days: ['السبت', 'الاثنين', 'الأربعاء'],
          time: '4:00 - 5:30 مساءً',
          location: 'قاعة A1',
          maxStudents: 15,
          currentStudents: 10,
          level: 'مبتدئ',
          status: 'نشط',
        ),
        QuranClass(
          id: 'class2',
          name: 'حلقة تحفيظ للأطفال',
          teacherId: 'teacher2',
          teacherName: 'نورة أحمد',
          days: ['الأحد', 'الثلاثاء', 'الخميس'],
          time: '5:00 - 6:30 مساءً',
          location: 'قاعة B2',
          maxStudents: 12,
          currentStudents: 8,
          level: 'مبتدئ',
          status: 'نشط',
        ),
        QuranClass(
          id: 'class3',
          name: 'حلقة التجويد المتقدمة',
          teacherId: 'teacher3',
          teacherName: 'خالد سلطان',
          days: ['السبت', 'الثلاثاء', 'الخميس'],
          time: '7:00 - 8:30 مساءً',
          location: 'قاعة C3',
          maxStudents: 10,
          currentStudents: 9,
          level: 'متقدم',
          status: 'نشط',
        ),
      ];
      
      setState(() {
        _classes = sampleClasses;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading classes: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تحميل بيانات الحلقات: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<QuranClass> get _filteredClasses {
    if (_searchQuery.isEmpty) {
      return _classes;
    }
    return _classes
        .where((qClass) =>
            qClass.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            qClass.teacherName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            qClass.level.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الحلقات'),
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
                labelText: 'بحث عن حلقة',
                hintText: 'ادخل اسم حلقة أو اسم معلم أو مستوى',
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

          // Class list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredClasses.isEmpty
                    ? const Center(
                        child: Text(
                          'لا يوجد حلقات للعرض',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredClasses.length,
                        itemBuilder: (context, index) {
                          final qClass = _filteredClasses[index];
                          return _buildClassCard(qClass);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditClassDialog(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'إضافة حلقة جديدة',
      ),
    );
  }

  Widget _buildClassCard(QuranClass qClass) {
    // Define level color
    Color levelColor;
    switch (qClass.level.toLowerCase()) {
      case 'مبتدئ':
        levelColor = Colors.green;
        break;
      case 'متوسط':
        levelColor = Colors.blue;
        break;
      case 'متقدم':
        levelColor = Colors.purple;
        break;
      default:
        levelColor = Colors.grey;
    }

    // Define status color
    Color statusColor;
    switch (qClass.status.toLowerCase()) {
      case 'نشط':
        statusColor = Colors.green;
        break;
      case 'معلق':
        statusColor = Colors.orange;
        break;
      case 'مكتمل':
        statusColor = Colors.blue;
        break;
      case 'ملغي':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    // Calculate capacity percentage
    double capacityPercentage = 
        qClass.maxStudents > 0 ? qClass.currentStudents / qClass.maxStudents : 0;
    
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
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  child: const Icon(
                    Icons.class_,
                    color: Colors.orange,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        qClass.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            qClass.teacherName,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: levelColor),
                  ),
                  child: Text(
                    qClass.level,
                    style: TextStyle(
                      color: levelColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
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
                  qClass.days.join(' - '),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  qClass.time,
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
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  qClass.location,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'السعة: ${qClass.currentStudents}/${qClass.maxStudents} طالب',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: capacityPercentage,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          capacityPercentage >= 0.9
                              ? Colors.red
                              : capacityPercentage >= 0.7
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    qClass.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
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
                    _showStudentsListDialog(context, qClass);
                  },
                  icon: const Icon(Icons.people, size: 18),
                  label: const Text('الطلاب'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _showAddEditClassDialog(context, qClass: qClass);
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('تعديل'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, qClass);
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

  void _showStudentsListDialog(BuildContext context, QuranClass qClass) {
    // Mock data for students in this class
    final List<Map<String, String>> students = [
      {'id': 'student1', 'name': 'أحمد محمد', 'grade': 'الصف الخامس'},
      {'id': 'student2', 'name': 'فاطمة علي', 'grade': 'الصف الرابع'},
      {'id': 'student3', 'name': 'محمد خالد', 'grade': 'الصف السادس'},
      {'id': 'student4', 'name': 'سارة أحمد', 'grade': 'الصف الخامس'},
      {'id': 'student5', 'name': 'عمر سعيد', 'grade': 'الصف السادس'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('طلاب حلقة ${qClass.name}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(student['name']!.characters.first),
                ),
                title: Text(student['name']!),
                subtitle: Text(student['grade']!),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: () {
                    // In full implementation, remove student from class
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('سيتم إضافة خاصية إزالة الطلاب من الحلقة قريباً'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to add students to class screen
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة خاصية إضافة طلاب للحلقة قريباً'),
                ),
              );
            },
            child: const Text('إضافة طلاب'),
          ),
        ],
      ),
    );
  }

  void _showAddEditClassDialog(BuildContext context, {QuranClass? qClass}) {
    final isEditing = qClass != null;
    final nameController = TextEditingController(text: isEditing ? qClass.name : '');
    final locationController = TextEditingController(text: isEditing ? qClass.location : '');
    final timeController = TextEditingController(text: isEditing ? qClass.time : '');
    final maxStudentsController = TextEditingController(
        text: isEditing ? qClass.maxStudents.toString() : '15');
    
    // Selected values for dropdowns and checkboxes
    String selectedTeacherId = isEditing ? qClass.teacherId : 'teacher1';
    String selectedTeacherName = isEditing ? qClass.teacherName : 'عبدالله محمد';
    String selectedLevel = isEditing ? qClass.level : 'مبتدئ';
    String selectedStatus = isEditing ? qClass.status : 'نشط';
    
    // Days of week checkboxes
    final List<String> daysOfWeek = [
      'السبت',
      'الأحد',
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
    ];
    
    List<String> selectedDays = isEditing ? List.from(qClass.days) : [];

    // Mock data for teachers dropdown
    final List<Map<String, String>> teachers = [
      {'id': 'teacher1', 'name': 'عبدالله محمد'},
      {'id': 'teacher2', 'name': 'نورة أحمد'},
      {'id': 'teacher3', 'name': 'خالد سلطان'},
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'تعديل بيانات الحلقة' : 'إضافة حلقة جديدة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الحلقة',
                    hintText: 'ادخل اسم الحلقة',
                  ),
                ),
                const SizedBox(height: 16),
                // Teacher dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'المعلم',
                  ),
                  value: selectedTeacherId,
                  items: teachers.map((teacher) {
                    return DropdownMenuItem<String>(
                      value: teacher['id'],
                      child: Text(teacher['name']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTeacherId = value;
                        selectedTeacherName = teachers
                            .firstWhere((t) => t['id'] == value)['name']!;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Level dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'المستوى',
                  ),
                  value: selectedLevel,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'مبتدئ',
                      child: Text('مبتدئ'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'متوسط',
                      child: Text('متوسط'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'متقدم',
                      child: Text('متقدم'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedLevel = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'المكان',
                    hintText: 'ادخل مكان الحلقة',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'الوقت',
                    hintText: 'مثال: 4:00 - 5:30 مساءً',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: maxStudentsController,
                  decoration: const InputDecoration(
                    labelText: 'الحد الأقصى للطلاب',
                    hintText: 'ادخل عدد الطلاب',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                // Status dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'الحالة',
                  ),
                  value: selectedStatus,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'نشط',
                      child: Text('نشط'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'معلق',
                      child: Text('معلق'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'مكتمل',
                      child: Text('مكتمل'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'ملغي',
                      child: Text('ملغي'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedStatus = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'أيام الحلقة:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children: daysOfWeek.map((day) {
                    return FilterChip(
                      label: Text(day),
                      selected: selectedDays.contains(day),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedDays.add(day);
                          } else {
                            selectedDays.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
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
                // Validate input
                if (nameController.text.isEmpty ||
                    locationController.text.isEmpty ||
                    timeController.text.isEmpty ||
                    maxStudentsController.text.isEmpty ||
                    selectedDays.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى ملء جميع الحقول المطلوبة واختيار يوم واحد على الأقل'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                int maxStudents;
                try {
                  maxStudents = int.parse(maxStudentsController.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى إدخال رقم صحيح للحد الأقصى للطلاب'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (isEditing) {
                  // Update existing class
                  final updatedClass = qClass.copyWith(
                    name: nameController.text,
                    teacherId: selectedTeacherId,
                    teacherName: selectedTeacherName,
                    days: selectedDays,
                    time: timeController.text,
                    location: locationController.text,
                    maxStudents: maxStudents,
                    level: selectedLevel,
                    status: selectedStatus,
                  );
                  
                  setState(() {
                    final index = _classes.indexWhere((c) => c.id == qClass.id);
                    if (index != -1) {
                      _classes[index] = updatedClass;
                    }
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تحديث بيانات الحلقة بنجاح'),
                    ),
                  );
                } else {
                  // Add new class
                  final newClass = QuranClass(
                    id: 'class_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text,
                    teacherId: selectedTeacherId,
                    teacherName: selectedTeacherName,
                    days: selectedDays,
                    time: timeController.text,
                    location: locationController.text,
                    maxStudents: maxStudents,
                    currentStudents: 0,
                    level: selectedLevel,
                    status: selectedStatus,
                  );
                  
                  setState(() {
                    _classes.add(newClass);
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إضافة الحلقة بنجاح'),
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

  void _showDeleteConfirmationDialog(BuildContext context, QuranClass qClass) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الحلقة ${qClass.name}؟'),
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
                _classes.removeWhere((c) => c.id == qClass.id);
              });
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف الحلقة بنجاح'),
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
}