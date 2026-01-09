class SignupValidators {
  static String? name(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Full name is required (e.g., John Smith)';
    }
    if (v.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digitsOnly = v.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      return 'Invalid phone number (e.g., (555) 123-4567)';
    }
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Email address is required';
    }
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(v)) {
      return 'Invalid email (e.g., john@example.com)';
    }
    return null;
  }

  static String? address(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Address is required (e.g., 123 Main St, City)';
    }
    if (v.trim().length < 10) {
      return 'Please enter a complete address';
    }
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) {
      return 'Password is required';
    }
    if (v.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(v)) {
      return 'Password must contain an uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(v)) {
      return 'Password must contain a lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(v)) {
      return 'Password must contain a number';
    }
    return null;
  }

  static String? confirmPassword(String? v, String password) {
    if (v == null || v.isEmpty) {
      return 'Please confirm your password';
    }
    if (v != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? bio(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Bio is required';
    }
    if (v.trim().length < 50) {
      return 'Bio must be at least 50 characters (${v.trim().length}/50)';
    }
    return null;
  }

  static String? farmName(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Farm name is required (e.g., Green Valley Farm)';
    }
    return null;
  }

  static String? location(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Location is required (e.g., Cairo, Egypt)';
    }
    return null;
  }

  static String? areaSize(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Area size is required';
    }
    if (double.tryParse(v) == null) {
      return 'Invalid number';
    }
    if (double.parse(v) <= 0) {
      return 'Area must be greater than 0';
    }
    return null;
  }

  static String? experience(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Years of experience is required';
    }
    if (int.tryParse(v) == null) {
      return 'Please enter a valid number';
    }
    final years = int.parse(v);
    if (years < 0) {
      return 'Cannot be negative';
    }
    if (years > 70) {
      return 'Please enter a realistic number';
    }
    return null;
  }
}

class AuthValidators {
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Email address is required';
    }
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(v)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) {
      return 'Password is required';
    }
    if (v.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
