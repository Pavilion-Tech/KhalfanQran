import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalfan_center/bloc/auth/auth_bloc.dart';
import 'package:khalfan_center/bloc/auth/auth_state.dart';
import 'package:khalfan_center/bloc/notifications/notifications_bloc.dart';
import 'package:khalfan_center/config/app_config.dart';
import 'package:khalfan_center/config/routes.dart';
import 'package:khalfan_center/config/themes.dart';
import 'package:khalfan_center/screens/admin/admin_dashboard.dart';
import 'package:khalfan_center/screens/parent/parent_dashboard.dart';
import 'package:khalfan_center/screens/student/student_dashboard.dart';
import 'package:khalfan_center/screens/teacher/teacher_dashboard.dart';
import 'package:khalfan_center/widgets/app_drawer.dart';
import 'package:khalfan_center/widgets/logo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _titles = [
    'الرئيسية',
    'الأخبار والفعاليات',
    'التقويم',
    'الملف الشخصي',
  ];
  
  @override
  void initState() {
    super.initState();
    // Load notifications
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<NotificationsBloc>().add(
        LoadUserNotificationsEvent(userId: authState.user.uid),
      );
    }
  }
  
  Widget _buildDashboardForRole(String? role) {
    switch (role) {
      case AppConfig.roleAdmin:
        return AdminDashboard();
      case AppConfig.roleSupervisor:
        return AdminDashboard(); // Similar to admin for now
      case AppConfig.roleTeacher:
        return TeacherDashboard();
      case AppConfig.roleStudent:
        return StudentDashboard();
      case AppConfig.roleParent:
      default:
        return ParentDashboard();
    }
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Navigate to appropriate screens for specific indices
    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.news);
    } else if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.calendar);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.profile);
    } else {
      setState(() {
        _currentIndex = 0;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_titles[_currentIndex]),
              centerTitle: true,
              actions: [
                BlocBuilder<NotificationsBloc, NotificationsState>(
                  builder: (context, notificationState) {
                    int unreadCount = 0;
                    if (notificationState is NotificationsLoaded) {
                      unreadCount = notificationState.unreadCount;
                    }
                    
                    return Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.notifications),
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.notifications);
                          },
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                unreadCount > 9 ? '9+' : '$unreadCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
            drawer: AppDrawer(
              userName: state.user.displayName ?? 'مستخدم',
              userEmail: state.user.email ?? '',
              userRole: state.role ?? AppConfig.roleParent,
            ),
            body: _currentIndex == 0
                ? _buildDashboardForRole(state.role)
                : Container(), // Other tabs navigate directly to their screens
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'الأخبار',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'التقويم',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'حسابي',
                ),
              ],
              currentIndex: _currentIndex,
              selectedItemColor: AppColors.primaryGreen,
              unselectedItemColor: AppColors.textSecondary,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
            ),
          );
        } else {
          // Fallback if user is not authenticated (shouldn't happen because of app routing)
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Logo(size: 120),
                  SizedBox(height: 24),
                  Text(
                    'يرجى تسجيل الدخول',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(SignOutEvent());
                    },
                    child: Text('تسجيل الدخول'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
