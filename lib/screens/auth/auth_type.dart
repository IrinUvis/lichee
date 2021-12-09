enum AuthType {
  login,
  register
}

extension AuthTypeExtension on AuthType {
  String getName() {
    return toString().split('.').last;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}