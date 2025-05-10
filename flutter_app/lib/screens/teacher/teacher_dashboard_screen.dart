import 'package:flutter/material.dart';
import 'package:khalfan_center/models/student_model.dart';
import 'package:khalfan_center/services/auth_service.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/widgets/admin/feature_grid_item.dart';
import 'package:khalfan_center/widgets/teacher/teacher_class_card.dart';

class TeacherDashboardScreen extends StatefulWidget {
  final AuthService authService;
  final FirebaseService firebaseService;
  final String teacherId;
  
  const TeacherDashboardScreen({
    Key? key,
    required this.authService,
    required this.firebaseService,
    required this.teacherId,
  }) : super(key: key);

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  List<StudentModel> _students = [];
  List<Map<String, dynamic>> _classes = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }
  
  Future<void> _loadTeacherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // استرجاع الطلاب المرتبطين بالمعلم
      final students = await widget.firebaseService.getStudentsForTeacher(widget.teacherId);
      
      // استرجاع الحلقات المرتبطة بالمعلم
      final classes = await widget.firebaseService.getAllClasses();
      final teacherClasses = classes.where((c) => c['teacherId'] == widget.teacherId).toList();
      
      setState(() {
        _students = students;
        _classes = teacherClasses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تحميل البيانات: $e';
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية للمعلم'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await widget.authService.signOut();
                if (mounted) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                print('Error signing out: $e');
              }
            },
          ),
        ],
      ),
      body: _buildBody(),
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
              onPressed: _loadTeacherData,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadTeacherData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            const Text(
              'مرحباً بك في نظام المعلم',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'مركز خلفان لتحفيظ القرآن الكريم',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick stats
            Row(
              children: [
                _buildStatsCard(
                  'الطلاب',
                  _students.length.toString(),
                  Icons.school,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildStatsCard(
                  'الحلقات',
                  _classes.length.toString(),
                  Icons.class_,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Features grid
            const Text(
              'الميزات المتاحة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                FeatureGridItem(
                  title: 'تسجيل الحضور',
                  icon: Icons.fact_check,
                  color: Colors.blue,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا: تسجيل الحضور'),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'متابعة التقدم',
                  icon: Icons.trending_up,
                  color: Colors.green,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا: متابعة التقدم'),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'الطلاب',
                  icon: Icons.people,
                  color: Colors.purple,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا: قائمة الطلاب'),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'الإعلانات',
                  icon: Icons.campaign,
                  color: Colors.orange,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا: الإعلانات'),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Classes section
            const Text(
              'الحلقات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_classes.isEmpty)
              const Center(
                child: Text('لا توجد حلقات مسجلة حاليًا'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _classes.length,
                itemBuilder: (context, index) {
                  final classData = _classes[index];
                  return TeacherClassCard(
                    classData: classData,
                    onTap: () {
                      // Open class details
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('قريبًا: تفاصيل الحلقة'),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24, color: color),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}