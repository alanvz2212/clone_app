class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (value.length > 20) {
      return 'Password must be less than 20 characters';
    }
    return null;
  }
  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 10) {
      return 'Mobile number must be at least 10 digits';
    }
    if (digitsOnly.length > 15) {
      return 'Mobile number must be less than 15 digits';
    }
    return null;
  }
  static String? validateMobileOrId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number or ID is required';
    }
    if (value.length < 3) {
      return 'Please enter a valid mobile number or ID';
    }
    return null;
  }
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
  static String? validateDealerId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Dealer ID is required';
    }
    if (value.length < 3) {
      return 'Dealer ID must be at least 3 characters long';
    }
    if (value.length > 20) {
      return 'Dealer ID must be less than 20 characters';
    }
    return null;
  }
  static String? validateTransporterId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Transporter ID is required';
    }
    if (value.length < 3) {
      return 'Transporter ID must be at least 3 characters long';
    }
    if (value.length > 20) {
      return 'Transporter ID must be less than 20 characters';
    }
    return null;
  }
  static String? validateLength(
    String? value,
    String fieldName,
    int minLength,
    int maxLength,
  ) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    if (value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }
    return null;
  }
  static bool isNumeric(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }
  static bool isAlphabetic(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(value);
  }
  static bool isAlphanumeric(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
  }
}

