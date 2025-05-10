import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalfan_center/bloc/auth/auth_bloc.dart';
import 'package:khalfan_center/bloc/user/user_bloc.dart';
import 'package:khalfan_center/config/app_config.dart';
import 'package:khalfan_center/config/routes.dart';
import 'package:khalfan_center/config/themes.dart';
import 'package:khalfan_center/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  
  void _loadUserProfile() {
    final userId = context.read<AuthBloc>().authService.currentUser?.uid;
    if (userId != null) {
      context.read<UserBloc>().add(LoadUserProfileEvent(userId: userId));
    }
  }
  
  String _getRoleName(String role) {
    switch (role) {
      case AppConfig.roleAdmin:
        return 'مدير النظام';
      case AppConfig.roleSupervisor:
        return 'مشرف';
      case AppConfig.roleTeacher:
        return 'معلم';
      case AppConfig.roleStudent:
        return 'طالب';
      case AppConfig.roleParent:
        return 'ولي أمر';
      default:
        return 'مستخدم';
    }
  }
  
  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تسجيل الخروج'),
        content: Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(SignOutEvent());
            },
            child: Text('تسجيل الخروج'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي'),
        centerTitle: true,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(state.message),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadUserProfile,
                    child: Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (state is UserLoaded) {
            UserModel user = state.user;
            return SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile header with avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primaryGreen,
                    backgroundImage: user.profileImageUrl.isNotEmpty
                        ? NetworkImage(user.profileImageUrl)
                        : null,
                    child: user.profileImageUrl.isEmpty
                        ? Text(
                            user.fullName.isNotEmpty
                                ? user.fullName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(height: 16),
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getRoleName(user.role),
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  
                  // Profile Information
                  _buildInfoSection(
                    context,
                    'معلومات الحساب',
                    [
                      _buildInfoItem(context, 'البريد الإلكتروني', user.email, Icons.email),
                      _buildInfoItem(context, 'رقم الهاتف', user.phone, Icons.phone),
                      _buildInfoItem(
                        context, 
                        'تاريخ الإنضمام', 
                        '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                        Icons.calendar_today,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Action Buttons
                  ElevatedButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text('تعديل الملف الشخصي'),
                    onPressed: () {
                      Navigator.pushNamed(
                        context, 
                        AppRoutes.editProfile,
                      ).then((_) => _loadUserProfile());
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: Icon(Icons.lock),
                    label: Text('تغيير كلمة المرور'),
                    onPressed: () {
                      _showChangePasswordDialog(context);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton.icon(
                    icon: Icon(Icons.logout, color: Colors.red),
                    label: Text(
                      'تسجيل الخروج',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: _signOut,
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: _loadUserProfile,
                child: Text('تحميل الملف الشخصي'),
              ),
            );
          }
        },
      ),
    );
  }
  
  Widget _buildInfoSection(BuildContext context, String title, List<Widget> items) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }
  
  Widget _buildInfoItem(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('تغيير كلمة المرور'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: obscureCurrentPassword,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الحالية',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureCurrentPassword = !obscureCurrentPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  obscureText: obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureNewPassword = !obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور الجديدة',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text.isEmpty || 
                    currentPasswordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('يرجى ملء جميع الحقول')),
                  );
                  return;
                }
                
                if (newPasswordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('كلمات المرور الجديدة غير متطابقة')),
                  );
                  return;
                }
                
                Navigator.pop(context);
                
                // Change password
                context.read<UserBloc>().add(
                  ChangePasswordEvent(
                    currentPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                  ),
                );
              },
              child: Text('تغيير كلمة المرور'),
            ),
          ],
        ),
      ),
    );
  }
}
