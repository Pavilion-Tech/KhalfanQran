import 'package:flutter/material.dart';
import 'package:khalfan_center/models/user_model.dart';

class AppDrawer extends StatelessWidget {
  final UserModel? user;
  final Function()? onProfileTap;
  final Function()? onHomeTap;
  final Function()? onCalendarTap;
  final Function()? onSettingsTap;
  final Function()? onLogoutTap;
  
  const AppDrawer({
    Key? key,
    this.user,
    this.onProfileTap,
    this.onHomeTap,
    this.onCalendarTap,
    this.onSettingsTap,
    this.onLogoutTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user?.name ?? 'مستخدم مركز خلفان',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _getInitials(user?.name),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('الرئيسية'),
            onTap: () {
              Navigator.pop(context);
              if (onHomeTap != null) {
                onHomeTap!();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'),
            onTap: () {
              Navigator.pop(context);
              if (onProfileTap != null) {
                onProfileTap!();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('التقويم والمواعيد'),
            onTap: () {
              Navigator.pop(context);
              if (onCalendarTap != null) {
                onCalendarTap!();
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'),
            onTap: () {
              Navigator.pop(context);
              if (onSettingsTap != null) {
                onSettingsTap!();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              Navigator.pop(context);
              if (onLogoutTap != null) {
                onLogoutTap!();
              }
            },
          ),
        ],
      ),
    );
  }
  
  String _getInitials(String? name) {
    if (name == null || name.isEmpty) {
      return 'ض';
    }
    
    final parts = name.split(' ');
    String initials = '';
    
    for (final part in parts) {
      if (part.isNotEmpty && initials.length < 2) {
        initials += part[0];
      }
    }
    
    return initials.isEmpty ? name[0] : initials;
  }
}