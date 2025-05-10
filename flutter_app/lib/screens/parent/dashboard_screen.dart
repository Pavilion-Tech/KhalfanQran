import 'package:flutter/material.dart';
import 'package:khalfan_center/config/themes.dart';
import 'package:khalfan_center/screens/parent/learning_plan_screen.dart';
import 'package:khalfan_center/screens/parent/progress_screen.dart';
import 'package:khalfan_center/screens/parent/attendance_screen.dart';
import 'package:khalfan_center/screens/parent/certificates_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardHomeTab(),
    LearningPlanScreen(),
    ProgressScreen(),
    AttendanceScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to profile screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications screen
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'خطة التعلم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'التقدم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'الحضور',
          ),
        ],
      ),
    );
  }
}

class DashboardHomeTab extends StatelessWidget {
  const DashboardHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryGreen,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'مرحباً، أحمد',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'آخر تسجيل دخول: ${DateTime.now().toString().substring(0, 10)}',
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
            ),
          ),

          // Quick stats
          const Text(
            'ملخص التقدم',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildStatCard(
                context,
                title: 'نسبة الحضور',
                value: '85%',
                icon: Icons.calendar_today,
                color: AppColors.primaryGreen,
              ),
              _buildStatCard(
                context,
                title: 'السور المحفوظة',
                value: '12',
                icon: Icons.menu_book,
                color: AppColors.secondaryBlue,
              ),
              _buildStatCard(
                context,
                title: 'عدد الاختبارات',
                value: '5',
                icon: Icons.assignment,
                color: AppColors.goldAccent,
              ),
              _buildStatCard(
                context,
                title: 'الشهادات',
                value: '3',
                icon: Icons.card_membership,
                color: AppColors.primaryGreen,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent activities
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'آخر الأنشطة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // View all activities
                },
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildActivityItem(
            context,
            title: 'تم تسجيل حضور الطالب',
            time: 'اليوم، 09:30 ص',
            icon: Icons.check_circle,
            iconColor: AppColors.success,
          ),
          _buildActivityItem(
            context,
            title: 'تم حفظ سورة الفاتحة بنجاح',
            time: 'أمس، 11:20 م',
            icon: Icons.menu_book,
            iconColor: AppColors.secondaryBlue,
          ),
          _buildActivityItem(
            context,
            title: 'تم إضافة واجب جديد',
            time: '15/05/2025، 10:00 ص',
            icon: Icons.assignment,
            iconColor: AppColors.goldAccent,
          ),

          const SizedBox(height: 24),

          // Upcoming events
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المواعيد القادمة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // View all events
                },
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildEventItem(
            context,
            title: 'اختبار حفظ',
            date: 'الأربعاء 20/05/2025',
            time: '10:00 ص',
            location: 'القاعة الرئيسية',
          ),
          _buildEventItem(
            context,
            title: 'اجتماع أولياء الأمور',
            date: 'الخميس 28/05/2025',
            time: '06:00 م',
            location: 'قاعة الاجتماعات',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required String title,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        title: Text(title),
        subtitle: Text(time),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // View activity details
        },
      ),
    );
  }

  Widget _buildEventItem(
    BuildContext context, {
    required String title,
    required String date,
    required String time,
    required String location,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date.split('/')[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Text(
                    'مايو',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}