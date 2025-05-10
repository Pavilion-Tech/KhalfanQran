import 'package:flutter/material.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/models/user_model.dart';

class ManageTeachers extends StatefulWidget {
  final FirebaseService? firebaseService;

  const ManageTeachers({
    Key? key,
    required this.firebaseService,
  }) : super(key: key);

  @override
  State<ManageTeachers> createState() => _ManageTeachersState();
}

class _ManageTeachersState extends State<ManageTeachers> {
  bool _isLoading = false;
  List<UserModel> _teachers = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTeachers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For now, we'll use sample data
      // In full implementation, fetch from Firebase
      await Future.delayed(const Duration(seconds: 1));
      
      final now = DateTime.now();
      final List<UserModel> sampleTeachers = [
        UserModel(
          id: 'teacher1',
          name: 'عبدالله محمد',
          email: 'abdullah@example.com',
          phone: '052-1234567',
          role: UserRole.teacher,
          createdAt: now.subtract(const Duration(days: 120)),
          lastLogin: now.subtract(const Duration(hours: 5)),
        ),
        UserModel(
          id: 'teacher2',
          name: 'نورة أحمد',
          email: 'noura@example.com',
          phone: '050-7654321',
          role: UserRole.teacher,
          createdAt: now.subtract(const Duration(days: 90)),
          lastLogin: now.subtract(const Duration(hours: 2)),
        ),
        UserModel(
          id: 'teacher3',
          name: 'خالد سلطان',
          email: 'khaled@example.com',
          phone: '055-9876543',
          role: UserRole.teacher,
          createdAt: now.subtract(const Duration(days: 180)),
          lastLogin: now.subtract(const Duration(days: 1)),
        ),
      ];
      
      setState(() {
        _teachers = sampleTeachers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading teachers: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تحميل بيانات المعلمين: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<UserModel> get _filteredTeachers {
    if (_searchQuery.isEmpty) {
      return _teachers;
    }
    return _teachers
        .where((teacher) =>
            teacher.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            teacher.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            teacher.phone.contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المعلمين'),
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
                labelText: 'بحث عن معلم',
                hintText: 'ادخل اسم أو بريد إلكتروني أو رقم هاتف',
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

          // Teacher list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTeachers.isEmpty
                    ? const Center(
                        child: Text(
                          'لا يوجد معلمين للعرض',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredTeachers.length,
                        itemBuilder: (context, index) {
                          final teacher = _filteredTeachers[index];
                          return _buildTeacherCard(teacher);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditTeacherDialog(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'إضافة معلم جديد',
      ),
    );
  }

  Widget _buildTeacherCard(UserModel teacher) {
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
                  backgroundColor: Colors.green.withOpacity(0.2),
                  child: Text(
                    teacher.name.characters.first,
                    style: const TextStyle(
                      color: Colors.green,
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
                        teacher.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        teacher.email,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Text(
                    'معلم',
                    style: TextStyle(
                      color: Colors.green,
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
                  Icons.phone,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  teacher.phone,
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
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'تاريخ الانضمام: ${_formatDate(teacher.createdAt)}',
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
                  'آخر تسجيل دخول: ${_formatTimeAgo(teacher.lastLogin)}',
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
                    _showTeacherDetailsDialog(context, teacher);
                  },
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('عرض التفاصيل'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _showAddEditTeacherDialog(context, teacher: teacher);
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('تعديل'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, teacher);
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTimeAgo(DateTime date) {
    final Duration difference = DateTime.now().difference(date);
    
    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  void _showTeacherDetailsDialog(BuildContext context, UserModel teacher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(teacher.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('البريد الإلكتروني', teacher.email),
              _buildDetailItem('رقم الهاتف', teacher.phone),
              _buildDetailItem('تاريخ الانضمام', _formatDate(teacher.createdAt)),
              _buildDetailItem('آخر تسجيل دخول', _formatTimeAgo(teacher.lastLogin)),
              const SizedBox(height: 16),
              const Text(
                'الطلاب المسجلين:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              // In full implementation, fetch and display students assigned to this teacher
              const Text('لا يوجد طلاب مسجلين حالياً'),
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
          ElevatedButton(
            onPressed: () {
              // Navigate to student assignment screen
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة خاصية تعيين الطلاب للمعلمين قريباً'),
                ),
              );
            },
            child: const Text('تعيين طلاب'),
          ),
        ],
      ),
    );
  }

  void _showAddEditTeacherDialog(BuildContext context, {UserModel? teacher}) {
    final isEditing = teacher != null;
    final nameController = TextEditingController(text: isEditing ? teacher.name : '');
    final emailController = TextEditingController(text: isEditing ? teacher.email : '');
    final phoneController = TextEditingController(text: isEditing ? teacher.phone : '');
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'تعديل بيانات المعلم' : 'إضافة معلم جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المعلم',
                  hintText: 'ادخل اسم المعلم',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  hintText: 'ادخل البريد الإلكتروني',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  hintText: 'ادخل رقم الهاتف',
                ),
                keyboardType: TextInputType.phone,
              ),
              if (!isEditing) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    hintText: 'ادخل كلمة المرور',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                const Text(
                  'سيتم إرسال بريد إلكتروني للمعلم بمعلومات تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
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
                  emailController.text.isEmpty ||
                  phoneController.text.isEmpty ||
                  (!isEditing && passwordController.text.isEmpty)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يرجى ملء جميع الحقول المطلوبة'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (isEditing) {
                // Update existing teacher
                final updatedTeacher = teacher.copyWith(
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                );
                
                setState(() {
                  final index = _teachers.indexWhere((t) => t.id == teacher.id);
                  if (index != -1) {
                    _teachers[index] = updatedTeacher;
                  }
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تحديث بيانات المعلم بنجاح'),
                  ),
                );
              } else {
                // Add new teacher
                final now = DateTime.now();
                final newTeacher = UserModel(
                  id: 'teacher_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  role: UserRole.teacher,
                  createdAt: now,
                  lastLogin: now,
                );
                
                setState(() {
                  _teachers.add(newTeacher);
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إضافة المعلم بنجاح'),
                  ),
                );
              }
              
              Navigator.pop(context);
            },
            child: Text(isEditing ? 'تحديث' : 'إضافة'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, UserModel teacher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المعلم ${teacher.name}؟'),
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
                _teachers.removeWhere((t) => t.id == teacher.id);
              });
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف المعلم بنجاح'),
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
}