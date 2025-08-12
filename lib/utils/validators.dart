class Validators {
  // Email validation
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

  // Password validation
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

  // Mobile number validation
  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }

    // Remove any non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Mobile number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Mobile number must be less than 15 digits';
    }

    return null;
  }

  // Mobile number or ID validation (for login)
  static String? validateMobileOrId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number or ID is required';
    }

    if (value.length < 3) {
      return 'Please enter a valid mobile number or ID';
    }

    return null;
  }

  // Name validation
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

    // Check if name contains only letters and spaces
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Dealer ID validation
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

  // Transporter ID validation
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

  // Generic length validation
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

  // Check if string contains only numbers
  static bool isNumeric(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  // Check if string contains only alphabets
  static bool isAlphabetic(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(value);
  }

  // Check if string is alphanumeric
  static bool isAlphanumeric(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
  }
}
