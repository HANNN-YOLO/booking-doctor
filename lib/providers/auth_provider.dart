import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _selectedRole = 'Pasien';
  String get selectedRole => _selectedRole;

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }
}
