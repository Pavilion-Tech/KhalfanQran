import 'package:flutter/material.dart';
import 'package:khalfan_center/models/student_model.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/widgets/admin/student_list_item.dart';
import 'package:khalfan_center/widgets/admin/student_form.dart';

class ManageStudentsScreen extends StatefulWidget {
  final FirebaseService firebaseService;
  
  const ManageStudentsScreen({
    Key? key,
    required this.firebaseService,
  }) : super(key: key);

  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  List<StudentModel> _students = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final students = await widget.firebaseService.getAllStudents();
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تحميل بيانات الطلاب: $e';
        _isLoading = false;
      });
    }
  }

  void _openAddStudentModal() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: StudentForm(
          firebaseService: widget.firebaseService,
          onStudentAdded: (StudentModel newStudent) {
            setState(() {
              _students.add(newStudent);
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _openEditStudentModal(StudentModel student) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: StudentForm(
          firebaseService: widget.firebaseService,
          student: student,
          onStudentUpdated: (StudentModel updatedStudent) {
            setState(() {
              final index = _students.indexWhere((s) => s.id == updatedStudent.id);
              if (index >= 0) {
                _students[index] = updatedStudent;
              }
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _deleteStudent(StudentModel student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف بيانات الطالب ${student.name}؟'),
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
        await widget.firebaseService.deleteStudent(student.id);
        setState(() {
          _students.removeWhere((s) => s.id == student.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف بيانات الطالب بنجاح')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء حذف بيانات الطالب: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلاب'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStudents,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddStudentModal,
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
              onPressed: _loadStudents,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_students.isEmpty) {
      return const Center(
        child: Text('لا يوجد طلاب حاليًا'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return StudentListItem(
          student: student,
          onEdit: () => _openEditStudentModal(student),
          onDelete: () => _deleteStudent(student),
          onViewProgress: () {
            // سيتم تنفيذه لاحقًا
          },
        );
      },
    );
  }
}