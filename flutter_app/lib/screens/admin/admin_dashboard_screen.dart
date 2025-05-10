import 'package:flutter/material.dart';
import 'package:khalfan_center/services/auth_service.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/screens/admin/manage_students_screen.dart';
import 'package:khalfan_center/screens/admin/manage_teachers_screen.dart';
import 'package:khalfan_center/widgets/admin/dashboard_stats_card.dart';
import 'package:khalfan_center/widgets/admin/feature_grid_item.dart';

class AdminDashboardScreen extends StatefulWidget {
  final AuthService? authService;
  final FirebaseService? firebaseService;
  
  const AdminDashboardScreen({
    Key? key,
    this.authService,
    this.firebaseService,
  }) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _studentsCount = 0;
  int _teachersCount = 0;
  int _classesCount = 0;
  int _announcementsCount = 0;
  bool _isLoading = true;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }
  
  Future<void> _loadDashboardData() async {
    if (widget.firebaseService == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'خدمة Firebase غير متوفرة';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final studentsCount = await widget.firebaseService!.getStudentsCount();
      final teachersCount = await widget.firebaseService!.getTeachersCount();
      final classesCount = await widget.firebaseService!.getClassesCount();
      final announcementsCount = await widget.firebaseService!.getAnnouncementsCount();
      
      setState(() {
        _studentsCount = studentsCount;
        _teachersCount = teachersCount;
        _classesCount = classesCount;
        _announcementsCount = announcementsCount;
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
        title: const Text('لوحة التحكم'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              if (widget.authService != null) {
                try {
                  await widget.authService!.signOut();
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  print('Error signing out: $e');
                }
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
              onPressed: _loadDashboardData,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            const Text(
              'مرحباً بك في لوحة التحكم',
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
            
            // Stats cards
            Row(
              children: [
                Expanded(
                  child: DashboardStatsCard(
                    title: 'الطلاب',
                    value: _studentsCount.toString(),
                    icon: Icons.school,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DashboardStatsCard(
                    title: 'المعلمين',
                    value: _teachersCount.toString(),
                    icon: Icons.person,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DashboardStatsCard(
                    title: 'الحلقات',
                    value: _classesCount.toString(),
                    icon: Icons.groups,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DashboardStatsCard(
                    title: 'الإعلانات',
                    value: _announcementsCount.toString(),
                    icon: Icons.campaign,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Features grid
            const Text(
              'الميزات الرئيسية',
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
                  title: 'إدارة الطلاب',
                  icon: Icons.school,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageStudentsScreen(
                          firebaseService: widget.firebaseService!,
                        ),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'إدارة المعلمين',
                  icon: Icons.person,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageTeachersScreen(
                          authService: widget.authService!,
                        ),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'إدارة الحلقات',
                  icon: Icons.groups,
                  color: Colors.purple,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا...'),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'إدارة الإعلانات',
                  icon: Icons.campaign,
                  color: Colors.orange,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا...'),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'تقارير الحضور',
                  icon: Icons.fact_check,
                  color: Colors.red,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا...'),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'تقارير التقدم',
                  icon: Icons.insights,
                  color: Colors.teal,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا...'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}