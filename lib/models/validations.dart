class Validations {
  static bool validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool validatePhone({required String phone}) {
    return RegExp(r'^(011|012|010|015)\d{8}$').hasMatch(phone);
  }

  static String validatePasswrd({required String password}) {
    if (password.toString().trim().isEmpty) {
      return "Enter a password!";
    } else if (password.toString().trim().length < 6) {
      return "Too short password!";
    } else {
      return "";
    }
  }

  static bool validateRepassword({repassword, password}) {
    return repassword.toString().trim() == password.toString().trim();
  }
}
