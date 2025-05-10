import 'package:flutter/material.dart';
import 'package:khalfan_center/services/auth_service.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/screens/admin/admin_dashboard_screen.dart';
import 'package:khalfan_center/screens/auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool firebaseInitialized;
  final AuthService? authService;
  final FirebaseService? firebaseService;
  
  const HomeScreen({
    Key? key, 
    this.firebaseInitialized = false,
    this.authService,
    this.firebaseService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز خلفان لتحفيظ القرآن الكريم'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with logo and welcome text
            Container(
              color: primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Logo placeholder
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'مرحباً بكم في',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'مركز خلفان لتحفيظ القرآن الكريم',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (authService != null) {
                            // Navigate to login screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                  authService: authService!,
                                ),
                              ),
                            );
                          } else {
                            // Auth service not available
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('جاري إعداد خدمة المصادقة، يرجى الانتظار...'),
                                duration: Duration(seconds: 5),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          backgroundColor: authService != null ? primaryColor : Colors.grey.shade400,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'تسجيل الدخول',
                              style: TextStyle(fontSize: 16),
                            ),
                            if (authService == null) ...[
                              const SizedBox(width: 8),
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Navigate to admin dashboard
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminDashboardScreen(
                                firebaseService: firebaseService,
                                authService: authService,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text(
                          'لوحة التحكم',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Features section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مميزات التطبيق',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildFeatureCard(
                        context,
                        icon: Icons.book,
                        title: 'خطة التعلم',
                        description: 'متابعة خطة الحفظ والمراجعة',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('سيتم تفعيل هذه الخاصية قريباً'),
                            ),
                          );
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.trending_up,
                        title: 'التقدم',
                        description: 'متابعة تقدم الطالب في الحفظ',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('سيتم تفعيل هذه الخاصية قريباً'),
                            ),
                          );
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.calendar_today,
                        title: 'الحضور والغياب',
                        description: 'سجل حضور الطالب والتقارير',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('سيتم تفعيل هذه الخاصية قريباً'),
                            ),
                          );
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.card_membership,
                        title: 'الشهادات',
                        description: 'عرض وتحميل شهادات الطالب',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('سيتم تفعيل هذه الخاصية قريباً'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // About section
            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'عن المركز',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'تأسس مركز خلفان لتحفيظ القرآن الكريم بهدف تعليم وتحفيظ كتاب الله عز وجل للطلاب من مختلف الأعمار. يوفر المركز بيئة تعليمية متميزة تجمع بين الأساليب التقليدية والتقنيات الحديثة.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildStatCard(
                        context,
                        title: '+500',
                        subtitle: 'طالب وطالبة',
                      ),
                      _buildStatCard(
                        context,
                        title: '+50',
                        subtitle: 'معلم ومعلمة',
                      ),
                      _buildStatCard(
                        context,
                        title: '+10',
                        subtitle: 'سنوات خبرة',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              color: primaryColor,
              child: Column(
                children: [
                  const Text(
                    'تواصل معنا',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.phone, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.email, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.location_on, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'جميع الحقوق محفوظة © 2025 مركز خلفان لتحفيظ القرآن الكريم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}