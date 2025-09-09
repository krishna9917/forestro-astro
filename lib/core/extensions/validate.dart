extension ValidationExtensions on String {
  bool isValidEmail() {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+(?:\.[a-zA-Z]+)?$');
    return emailRegex.hasMatch(this);
  }

  bool isValidPhoneNumber() {
    final RegExp phoneRegex = RegExp(
        r'^\+?([0-9]{1,4})?[\s.-]?([0-9]{3})[\s.-]?([0-9]{3})[\s.-]?([0-9]{4})$');
    return phoneRegex.hasMatch(this);
  }
}
