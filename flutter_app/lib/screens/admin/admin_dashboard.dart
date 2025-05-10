import 'package:flutter/material.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/services/auth_service.dart';

class AdminDashboard extends StatefulWidget {
  final FirebaseService? firebaseService;
  final AuthService? authService;
  
  const AdminDashboard({
    Key? key,
    required this.firebaseService,
    required this.authService,
  }) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  int _totalStudents = 0;
  int _totalTeachers = 0;
  int _totalClasses = 0;
  int _totalAnnouncements = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    if (widget.firebaseService != null) {
      try {
        // For now, we'll use placeholder data
        // In the full implementation, you would get this from Firestore
        await Future.delayed(const Duration(seconds: 1));
        
        setState(() {
          _totalStudents = 45;
          _totalTeachers = 12;
          _totalClasses = 8;
          _totalAnnouncements = 5;
          _isLoading = false;
        });
      } catch (e) {
        print('Error loading dashboard data: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Fallback when Firebase service is not available
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المدير'),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboardHome(),
          _buildManageStudents(),
          _buildManageTeachers(),
          _buildManageClasses(),
          _buildManageAnnouncements(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'مدير النظام',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'مركز خلفان لتحفيظ القرآن الكريم',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('الرئيسية'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('إدارة الطلاب'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('إدارة المعلمين'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_),
              title: const Text('إدارة الحلقات'),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.campaign),
              title: const Text('إدارة الإعلانات'),
              selected: _selectedIndex == 4,
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('الإعدادات'),
              onTap: () {
                // Navigate to settings
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('عن التطبيق'),
              onTap: () {
                // Show about dialog
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Dashboard Home Screen
  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'لوحة المعلومات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildStatCard(
                      context,
                      title: 'الطلاب',
                      count: _totalStudents,
                      iconData: Icons.person,
                      color: Colors.blue,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                    _buildStatCard(
                      context,
                      title: 'المعلمين',
                      count: _totalTeachers,
                      iconData: Icons.school,
                      color: Colors.green,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                    ),
                    _buildStatCard(
                      context,
                      title: 'الحلقات',
                      count: _totalClasses,
                      iconData: Icons.class_,
                      color: Colors.orange,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
                    ),
                    _buildStatCard(
                      context,
                      title: 'الإعلانات',
                      count: _totalAnnouncements,
                      iconData: Icons.campaign,
                      color: Colors.purple,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 4;
                        });
                      },
                    ),
                  ],
                ),
          const SizedBox(height: 30),
          const Text(
            'الإحصائيات الأخيرة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            _buildRecentActivitiesCard(context),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _loadDashboardData();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('تحديث البيانات'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Manage Students Screen
  Widget _buildManageStudents() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person,
            size: 64,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          const Text(
            'إدارة الطلاب',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يمكنك إضافة وتعديل وحذف بيانات الطلاب',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add student screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة شاشة إضافة طالب جديد قريباً'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة طالب جديد'),
          ),
        ],
      ),
    );
  }

  // Manage Teachers Screen
  Widget _buildManageTeachers() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.school,
            size: 64,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          const Text(
            'إدارة المعلمين',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يمكنك إضافة وتعديل وحذف بيانات المعلمين',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add teacher screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة شاشة إضافة معلم جديد قريباً'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة معلم جديد'),
          ),
        ],
      ),
    );
  }

  // Manage Classes Screen
  Widget _buildManageClasses() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.class_,
            size: 64,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          const Text(
            'إدارة الحلقات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يمكنك إضافة وتعديل وحذف بيانات الحلقات',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add class screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة شاشة إضافة حلقة جديدة قريباً'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة حلقة جديدة'),
          ),
        ],
      ),
    );
  }

  // Manage Announcements Screen
  Widget _buildManageAnnouncements() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.campaign,
            size: 64,
            color: Colors.purple,
          ),
          const SizedBox(height: 16),
          const Text(
            'إدارة الإعلانات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يمكنك إضافة وتعديل وحذف بيانات الإعلانات',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add announcement screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة شاشة إضافة إعلان جديد قريباً'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة إعلان جديد'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required int count,
    required IconData iconData,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
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

  Widget _buildRecentActivitiesCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'النشاطات الأخيرة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              context,
              icon: Icons.person_add,
              color: Colors.green,
              title: 'تم إضافة طالب جديد',
              subtitle: 'منذ 2 ساعة',
            ),
            const Divider(),
            _buildActivityItem(
              context,
              icon: Icons.event,
              color: Colors.blue,
              title: 'تم تعديل موعد حلقة',
              subtitle: 'منذ 5 ساعات',
            ),
            const Divider(),
            _buildActivityItem(
              context,
              icon: Icons.campaign,
              color: Colors.orange,
              title: 'تم إضافة إعلان جديد',
              subtitle: 'منذ يوم واحد',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}