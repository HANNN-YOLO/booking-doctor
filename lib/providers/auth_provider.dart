import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/daftar.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  String? _role;
  String _selectedRole = 'Pasien';
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  String? get role => _role;
  String get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _role == 'Admin';
  bool get isPasien => _role == 'Pasien';

  // Notifikasi
  void pemberitahuan(String pesan, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void pemberitahuanError(String pesan, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Navigation based on role
  void navigateBasedOnRole(BuildContext context) {
    if (_role == 'Admin') {
      Navigator.pushReplacementNamed(context, '/kekuatan_admin');
    } else if (_role == 'Pasien') {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        // Load role when user is authenticated
        _role = await _authService.getUserRole(user.uid);
      } else {
        _role = null;
      }
      notifyListeners();
    });
  }

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Register new user
  Future<bool> register(Daftar daftar, BuildContext context) async {
    try {
      _isLoading = true;
      _setError(null);
      notifyListeners();

      await _authService.registerWithEmailAndPassword(daftar);
      pemberitahuan('Registrasi berhasil!', context);
      return true;
    } catch (e) {
      _setError(e.toString());
      pemberitahuanError('Registrasi gagal: ${e.toString()}', context);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login user
  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      _isLoading = true;
      _setError(null);
      notifyListeners();

      final result =
          await _authService.loginWithEmailAndPassword(email, password);
      _user = result['user'] as User?;
      _role = result['role'] as String?;

      if (_user != null && _role != null) {
        pemberitahuan('Login berhasil!', context);
        // Navigate based on role after successful login
        navigateBasedOnRole(context);
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      pemberitahuanError('Login gagal: ${e.toString()}', context);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    try {
      await _authService.signOut();
      _user = null;
      _role = null;
      pemberitahuan('Logout berhasil!', context);
      // Navigate back to login screen after logout
      Navigator.pushReplacementNamed(context, '/login');
      notifyListeners();
    } catch (e) {
      _setError('Error signing out: $e');
      pemberitahuanError('Logout gagal: ${e.toString()}', context);
    }
  }

  // Handle Firebase Auth errors
  String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'weak-password':
          return 'Password terlalu lemah';
        case 'email-already-in-use':
          return 'Email sudah terdaftar';
        case 'invalid-email':
          return 'Email tidak valid';
        case 'user-not-found':
          return 'User tidak ditemukan';
        case 'wrong-password':
          return 'Password salah';
        default:
          return 'Terjadi kesalahan: ${e.message}';
      }
    }
    return 'Terjadi kesalahan yang tidak diketahui';
  }
}
