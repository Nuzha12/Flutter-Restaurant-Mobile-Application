class Validators {
  Validators._();

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final r = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!r.hasMatch(v.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? v, String pass) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != pass) return 'Passwords do not match';
    return null;
  }

  static String? name(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (v.trim().length < 2) return 'Must be at least 2 characters';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';
    final r = RegExp(r'^\+?[\d\s\-\(\)]{7,15}$');
    if (!r.hasMatch(v.trim())) return 'Enter a valid phone number';
    return null;
  }

  static String? required(String? v, String field) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? minLength(String? v, int len, String field) {
    if (v == null || v.trim().length < len) return '$field must be at least $len characters';
    return null;
  }

  static String? promoCode(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter a promo code';
    if (v.trim().length < 3) return 'Invalid promo code';
    return null;
  }
}