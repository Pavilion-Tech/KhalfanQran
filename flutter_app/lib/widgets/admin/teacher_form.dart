import 'package:flutter/material.dart';
import 'package:khalfan_center/models/user_model.dart';
import 'package:khalfan_center/services/auth_service.dart';

class TeacherForm extends StatefulWidget {
  final AuthService authService;
  final UserModel? teacher;
  final Function(UserModel)? onTeacherAdded;
  final Function(UserModel)? onTeacherUpdated;

  const TeacherForm({
    Key? key,
    required this.authService,
    this.teacher,
    this.onTeacherAdded,
    this.onTeacherUpdated,
  }) : super(key: key);

  @override
  State<TeacherForm> createState() => _TeacherFormState();
}

class _TeacherFormState extends State<TeacherForm> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isSubmitting = false;
  String _errorMessage = '';
  bool _isEditMode = false;
  
  @override
  void initState() {
    super.initState();
    _isEditMode = widget.teacher != null;
    
    if (_isEditMode) {
      _nameController.text = widget.teacher!.name;
      _emailController.text = widget.teacher!.email;
      _phoneController.text = widget.teacher!.phone;
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = '';
      });
      
      try {
        if (_isEditMode) {
          // Update existing teacher
          final updatedTeacher = UserModel(
            id: widget.teacher!.id,
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            role: UserRole.teacher,
            createdAt: widget.teacher!.createdAt,
            lastLogin: widget.teacher!.lastLogin,
          );
          
          await widget.authService.updateUserProfile(updatedTeacher);
          
          if (widget.onTeacherUpdated != null) {
            widget.onTeacherUpdated!(updatedTeacher);
          }
        } else {
          // Create new teacher
          final credential = await widget.authService.signUpWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
            fullName: _nameController.text,
            phone: _phoneController.text,
            role: UserRole.teacher,
          );
          
          // Get user model from auth service
          final newTeacher = await widget.authService.getUserById(credential.user!.uid);
          
          if (newTeacher != null && widget.onTeacherAdded != null) {
            widget.onTeacherAdded!(newTeacher);
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'حدث خطأ: $e';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditMode ? 'تعديل بيانات المعلم' : 'إضافة معلم جديد',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم المعلم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'الرجاء إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
                readOnly: _isEditMode, // لا يمكن تغيير البريد في وضع التعديل
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (!_isEditMode) ...[
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (_errorMessage.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red[50],
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isEditMode ? 'تحديث' : 'إضافة'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}