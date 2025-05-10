import 'package:flutter/material.dart';
import 'package:khalfan_center/models/user_model.dart';
import 'package:khalfan_center/services/auth_service.dart';
import 'package:khalfan_center/widgets/admin/teacher_list_item.dart';
import 'package:khalfan_center/widgets/admin/teacher_form.dart';

class ManageTeachersScreen extends StatefulWidget {
  final AuthService authService;
  
  const ManageTeachersScreen({
    Key? key,
    required this.authService,
  }) : super(key: key);

  @override
  State<ManageTeachersScreen> createState() => _ManageTeachersScreenState();
}

class _ManageTeachersScreenState extends State<ManageTeachersScreen> {
  List<UserModel> _teachers = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final teachers = await widget.authService.getAllTeachers();
      setState(() {
        _teachers = teachers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تحميل بيانات المعلمين: $e';
        _isLoading = false;
      });
    }
  }

  void _openAddTeacherModal() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: TeacherForm(
          authService: widget.authService,
          onTeacherAdded: (UserModel newTeacher) {
            setState(() {
              _teachers.add(newTeacher);
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _openEditTeacherModal(UserModel teacher) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: TeacherForm(
          authService: widget.authService,
          teacher: teacher,
          onTeacherUpdated: (UserModel updatedTeacher) {
            setState(() {
              final index = _teachers.indexWhere((t) => t.id == updatedTeacher.id);
              if (index >= 0) {
                _teachers[index] = updatedTeacher;
              }
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _deleteTeacher(UserModel teacher) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المعلم ${teacher.name}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.authService.deleteUserAccount(teacher.id);
        setState(() {
          _teachers.removeWhere((t) => t.id == teacher.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف المعلم بنجاح')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء حذف المعلم: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المعلمين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTeachers,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTeacherModal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTeachers,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_teachers.isEmpty) {
      return const Center(
        child: Text('لا يوجد معلمين حالياً'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _teachers.length,
      itemBuilder: (context, index) {
        final teacher = _teachers[index];
        return TeacherListItem(
          teacher: teacher,
          onEdit: () => _openEditTeacherModal(teacher),
          onDelete: () => _deleteTeacher(teacher),
        );
      },
    );
  }
}