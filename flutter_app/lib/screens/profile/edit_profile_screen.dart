import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalfan_center/bloc/auth/auth_bloc.dart';
import 'package:khalfan_center/bloc/user/user_bloc.dart';
import 'package:khalfan_center/config/themes.dart';
import 'package:khalfan_center/models/user_model.dart';
import 'package:khalfan_center/utils/validators.dart';
import 'package:khalfan_center/widgets/custom_button.dart';
import 'package:khalfan_center/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  File? _imageFile;
  bool _isLoading = false;
  UserModel? _user;
  
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  
  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  void _loadUserProfile() {
    final userId = context.read<AuthBloc>().authService.currentUser?.uid;
    if (userId != null) {
      context.read<UserBloc>().add(LoadUserProfileEvent(userId: userId));
    }
  }
  
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في اختيار الصورة: $e')),
      );
    }
  }
  
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اختر صورة الملف الشخصي',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Camera option
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: AppColors.primaryGreen,
                          size: 28,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('الكاميرا'),
                    ],
                  ),
                ),
                
                // Gallery option
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.photo_library,
                          color: AppColors.primaryGreen,
                          size: 28,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('المعرض'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_user?.profileImageUrl.isNotEmpty == true)
              TextButton.icon(
                icon: Icon(Icons.delete, color: Colors.red),
                label: Text(
                  'حذف الصورة الحالية',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _imageFile = null);
                  // Later we will need to implement actual deletion logic
                },
              ),
          ],
        ),
      ),
    );
  }
  
  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      if (_user == null) return;
      
      final userId = context.read<AuthBloc>().authService.currentUser?.uid;
      if (userId == null) return;
      
      // First update profile data
      context.read<UserBloc>().add(
        UpdateUserProfileEvent(
          userId: userId,
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
        ),
      );
      
      // Then upload image if it was changed
      if (_imageFile != null) {
        context.read<UserBloc>().add(
          UpdateUserProfileImageEvent(
            userId: userId,
            imageFile: _imageFile!,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الملف الشخصي'),
        centerTitle: true,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }
          
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          
          if (state is UserLoaded) {
            _user = state.user;
            
            // Initialize controllers if they haven't been initialized
            if (_fullNameController.text.isEmpty) {
              _fullNameController.text = _user!.fullName;
            }
            
            if (_phoneController.text.isEmpty) {
              _phoneController.text = _user!.phone;
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile image
                    GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: AppColors.primaryGreen,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : (_user?.profileImageUrl.isNotEmpty == true
                                    ? NetworkImage(_user!.profileImageUrl)
                                    : null),
                            child: _imageFile == null && _user?.profileImageUrl.isEmpty != false
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'تغيير صورة الملف الشخصي',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 32),
                    
                    // Form fields
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
                      controller: _phoneController,
                      hintText: 'رقم الهاتف',
                      labelText: 'رقم الهاتف',
                      prefixIcon: Icon(Icons.phone),
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhone,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 16),
                    
                    // Email field (readonly)
                    TextFormField(
                      initialValue: _user?.email ?? '',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني (لا يمكن تغييره)',
                        hintText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 32),
                    
                    // Submit button
                    CustomButton(
                      text: 'حفظ التغييرات',
                      isLoading: _isLoading,
                      onPressed: _updateProfile,
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
