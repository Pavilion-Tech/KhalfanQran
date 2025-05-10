import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalfan_center/bloc/auth/auth_bloc.dart';
import 'package:khalfan_center/bloc/auth/auth_state.dart';
import 'package:khalfan_center/config/routes.dart';
import 'package:khalfan_center/utils/validators.dart';
import 'package:khalfan_center/widgets/custom_button.dart';
import 'package:khalfan_center/widgets/custom_text_field.dart';
import 'package:khalfan_center/widgets/logo.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(
        ResetPasswordEvent(
          email: _emailController.text.trim(),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('استعادة كلمة المرور'),
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
          
          if (state is AuthPasswordResetSent) {
            setState(() => _emailSent = true);
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
                    SizedBox(height: 32),
                    
                    if (_emailSent) ...[
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 80,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'تم إرسال رابط استعادة كلمة المرور',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'تم إرسال رابط لإعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى التحقق من البريد الوارد واتباع التعليمات لإعادة تعيين كلمة المرور الخاصة بك.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      CustomButton(
                        text: 'العودة إلى تسجيل الدخول',
                        onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                      ),
                    ] else ...[
                      Text(
                        'نسيت كلمة المرور؟',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'لا تقلق! أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور الخاصة بك.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'البريد الإلكتروني',
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                        enabled: !_isLoading,
                      ),
                      SizedBox(height: 24),
                      CustomButton(
                        text: 'إرسال رابط الاستعادة',
                        isLoading: _isLoading,
                        onPressed: _resetPassword,
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: !_isLoading 
                          ? () => Navigator.pushReplacementNamed(context, AppRoutes.login) 
                          : null,
                        child: Text('العودة إلى تسجيل الدخول'),
                      ),
                    ],
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
