import 'package:flutter/material.dart';
import 'package:khalfan_center/models/user_model.dart';
import 'package:khalfan_center/services/auth_service.dart';
import 'package:khalfan_center/screens/admin/admin_dashboard_screen.dart';
import 'package:khalfan_center/screens/parent/parent_dashboard_screen.dart';
import 'package:khalfan_center/screens/teacher/teacher_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;
  
  const LoginScreen({
    Key? key,
    required this.authService,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      try {
        final user = await widget.authService.loginWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        
        if (user != null) {
          _navigateBasedOnRole(user);
        } else {
          setState(() {
            _errorMessage = 'فشل تسجيل الدخول. الرجاء التحقق من بريدك الإلكتروني وكلمة المرور.';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'حدث خطأ: $e';
          _isLoading = false;
        });
      }
    }
  }
  
  void _navigateBasedOnRole(UserModel user) {
    Widget dashboard;
    
    switch (user.role) {
      case UserRole.admin:
        dashboard = AdminDashboardScreen(
          authService: widget.authService,
          firebaseService: widget.authService.getFirebaseService(),
        );
        break;
      case UserRole.teacher:
        dashboard = TeacherDashboardScreen(
          authService: widget.authService,
          firebaseService: widget.authService.getFirebaseService(),
          teacherId: user.id,
        );
        break;
      case UserRole.parent:
        dashboard = ParentDashboardScreen(
          authService: widget.authService,
          firebaseService: widget.authService.getFirebaseService(),
          parentId: user.id,
        );
        break;
      default:
        setState(() {
          _errorMessage = 'نوع المستخدم غير معروف';
          _isLoading = false;
        });
        return;
    }
    
    // Navigate to the dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and title
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.menu_book,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'مركز خلفان لتحفيظ القرآن الكريم',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'تسجيل الدخول للنظام',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48),
                
                // Login form
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              // يمكن تنفيذ وظيفة نسيت كلمة المرور لاحقًا
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('قريبًا: وظيفة استعادة كلمة المرور'),
                                ),
                              );
                            },
                            child: const Text('نسيت كلمة المرور؟'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                        if (_errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.red[50],
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // Divider with "or" text
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'أو',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Sample credentials for demo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'بيانات تسجيل الدخول للعرض التجريبي',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'مدير: admin@example.com / 123456\nمعلم: abdullah@example.com / 123456\nولي أمر: mohammed@example.com / 123456',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          // العودة إلى الصفحة الرئيسية
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        child: const Text('العودة للصفحة الرئيسية'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}