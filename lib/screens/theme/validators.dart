/// ===========================================================
/// Validators
/// -----------------------------------------------------------
/// Common validation methods.
/// ===========================================================
library;

class Validators {
  Validators._();

  static String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return "Password cannot be empty";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    return null;
  }
  static String? validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) {
      return "Confirm your password";
    }

    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    return null;
  }
}