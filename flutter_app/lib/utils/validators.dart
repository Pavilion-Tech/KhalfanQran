/// مجموعة من الدوال للتحقق من صحة البيانات المدخلة
class Validators {
  /// التحقق من البريد الإلكتروني
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    
    return null;
  }

  /// التحقق من كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    
    if (value.length < 6) {
      return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
    }
    
    return null;
  }

  /// التحقق من تطابق كلمة المرور
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    
    if (value != password) {
      return 'كلمات المرور غير متطابقة';
    }
    
    return null;
  }

  /// التحقق من الاسم
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال الاسم';
    }
    
    if (value.length < 3) {
      return 'يجب أن يكون الاسم 3 أحرف على الأقل';
    }
    
    return null;
  }

  /// التحقق من رقم الهاتف
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    
    // تحقق بسيط من تنسيق الرقم الإماراتي
    final phoneRegExp = RegExp(r'^(05|5|\+9715|\+971 5)[0-9]{8}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'يرجى إدخال رقم هاتف صحيح (مثال: 05xxxxxxxx)';
    }
    
    return null;
  }

  /// التحقق من رقم الهوية الإماراتية
  static String? validateEmiratesId(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم الهوية الإماراتية';
    }
    
    // تحقق بسيط من تنسيق الهوية الإماراتية
    final idRegExp = RegExp(r'^784-[0-9]{4}-[0-9]{7}-[0-9]{1}$');
    if (!idRegExp.hasMatch(value)) {
      return 'يرجى إدخال رقم هوية إماراتية صحيح (مثال: 784-xxxx-xxxxxxx-x)';
    }
    
    return null;
  }

  /// التحقق من أي حقل مطلوب
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    
    return null;
  }
}