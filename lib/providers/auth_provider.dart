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
        // Load user profile and check role
        final userProfile = await _authService.getUserProfile(user.uid);
        _role = userProfile?['role'] as String?;
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

      // Menggunakan method baru dari AuthService
      await _authService.registerUser(
        email: daftar.email!,
        password: daftar.password!,
        name: daftar.nama!,
        role: daftar.role!,
      );

      pemberitahuan('Registrasi berhasil!', context);
      return true;
    } catch (e) {
      _setError(_handleAuthError(e));
      pemberitahuanError('Registrasi gagal: ${_handleAuthError(e)}', context);
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

      // Menggunakan method baru dari AuthService
      final userCredential = await _authService.loginUser(
        email: email,
        password: password,
      );

      _user = userCredential.user;

      if (_user != null) {
        // Ambil data profil user
        final userProfile = await _authService.getUserProfile(_user!.uid);
        _role = userProfile?['role'] as String?;

        if (_role != null) {
          pemberitahuan('Login berhasil!', context);
          navigateBasedOnRole(context);
          return true;
        }
      }

      throw Exception('Gagal mendapatkan data user');
    } catch (e) {
      _setError(_handleAuthError(e));
      pemberitahuanError('Login gagal: ${_handleAuthError(e)}', context);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    try {
      await _authService.logout();
      _user = null;
      _role = null;
      pemberitahuan('Logout berhasil!', context);
      Navigator.pushReplacementNamed(context, '/login');
      notifyListeners();
    } catch (e) {
      _setError(_handleAuthError(e));
      pemberitahuanError('Logout gagal: ${_handleAuthError(e)}', context);
    }
  }

  // Handle Firebase Auth errors
  String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'weak-password':
          return 'Password terlalu lemah (minimal 6 karakter)';
        case 'email-already-in-use':
          return 'Email sudah terdaftar';
        case 'invalid-email':
          return 'Format email tidak valid';
        case 'user-not-found':
          return 'Email tidak terdaftar';
        case 'wrong-password':
          return 'Password salah';
        case 'user-disabled':
          return 'Akun telah dinonaktifkan';
        case 'operation-not-allowed':
          return 'Operasi tidak diizinkan';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan. Silakan coba lagi nanti';
        default:
          return 'Terjadi kesalahan: ${e.message}';
      }
    }
    return e.toString();
  }
}
