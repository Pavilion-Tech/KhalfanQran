import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalfan_center/bloc/auth/auth_bloc.dart';
import 'package:khalfan_center/bloc/auth/auth_state.dart';
import 'package:khalfan_center/config/app_config.dart';
import 'package:khalfan_center/config/routes.dart';
import 'package:khalfan_center/utils/validators.dart';
import 'package:khalfan_center/widgets/custom_button.dart';
import 'package:khalfan_center/widgets/custom_text_field.dart';
import 'package:khalfan_center/widgets/logo.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = AppConfig.roleParent;
  
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
  
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }
  
  void _register() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      
      // Make sure passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('كلمات المرور غير متطابقة')),
        );
        return;
      }
      
      context.read<AuthBloc>().add(
        SignUpWithEmailEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
          role: _selectedRole,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء حساب جديد'),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }
          
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: Logo(size: 80)),
                    SizedBox(height: 24),
                    Text(
                      'أهلاً بك في مركز خلفان لتحفيظ القرآن الكريم',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'الرجاء إدخال معلوماتك لإنشاء حساب جديد',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    
                    // Role Selection
                    Text(
                      'اختر نوع الحساب:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: AppConfig.roleParent,
                          child: Text('ولي أمر'),
                        ),
                        DropdownMenuItem(
                          value: AppConfig.roleStudent,
                          child: Text('طالب'),
                        ),
                      ],
                      onChanged: !_isLoading 
                        ? (value) => setState(() => _selectedRole = value!) 
                        : null,
                    ),
                    SizedBox(height: 24),
                    
                    // Registration Form
                    CustomTextField(
                      controller: _fullNameController,
                      hintText: 'الاسم الكامل',
                      labelText: 'الاسم الكامل',
                      prefixIcon: Icon(Icons.person),
                      validator: Validators.validateName,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'البريد الإلكتروني',
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: 'رقم الهاتف',
                      labelText: 'رقم الهاتف',
                      prefixIcon: Icon(Icons.phone),
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhone,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'كلمة المرور',
                      labelText: 'كلمة المرور',
                      prefixIcon: Icon(Icons.lock),
                      obscureText: _obscurePassword,
                      validator: Validators.validatePassword,
                      enabled: !_isLoading,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'تأكيد كلمة المرور',
                      labelText: 'تأكيد كلمة المرور',
                      prefixIcon: Icon(Icons.lock_outline),
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'كلمات المرور غير متطابقة';
                        }
                        return null;
                      },
                      enabled: !_isLoading,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: _toggleConfirmPasswordVisibility,
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Terms & Conditions
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (value) {},
                        ),
                        Expanded(
                          child: Text(
                            'بالتسجيل، أنت توافق على شروط الاستخدام وسياسة الخصوصية',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    
                    CustomButton(
                      text: 'إنشاء الحساب',
                      isLoading: _isLoading,
                      onPressed: _register,
                    ),
                    SizedBox(height: 24),
                    
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('لديك حساب بالفعل؟'),
                        TextButton(
                          onPressed: !_isLoading 
                            ? () => Navigator.pushReplacementNamed(context, AppRoutes.login) 
                            : null,
                          child: Text('تسجيل الدخول'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
