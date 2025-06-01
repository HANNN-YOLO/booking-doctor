import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/daftar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Register dengan email dan password
  Future<UserCredential> registerWithEmailAndPassword(Daftar daftar) async {
    // Validasi data
    if (daftar.email == null || daftar.email!.isEmpty) {
      throw 'Email tidak boleh kosong';
    }
    if (daftar.password == null || daftar.password!.isEmpty) {
      throw 'Password tidak boleh kosong';
    }
    if (daftar.role == null || daftar.role!.isEmpty) {
      throw 'Role tidak boleh kosong';
    }

    try {
      // 1. Buat akun di Firebase Auth
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: daftar.email!,
        password: daftar.password!,
      );

      // 2. Simpan data user di Realtime Database
      if (userCredential.user != null) {
        await _createUserData(userCredential.user!.uid, daftar);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Terjadi kesalahan saat registrasi: $e';
    }
  }

  // Simpan data user di database
  Future<void> _createUserData(String uid, Daftar daftar) async {
    try {
      // Simpan data dasar user
      await _database.child('users').child(uid).set({
        'email': daftar.email,
        'role': daftar.role,
        'nama': daftar.nama,
        'created_at': ServerValue.timestamp,
        'updated_at': ServerValue.timestamp,
      });

      // Jika rolenya Pasien, buat juga profil pasien
      if (daftar.role == 'Pasien') {
        await _database.child('pasien_profiles').child(uid).set({
          'nama': daftar.nama,
          'email': daftar.email,
          'created_at': ServerValue.timestamp,
        });
      }
    } catch (e) {
      // Jika gagal menyimpan data, hapus user auth
      await _auth.currentUser?.delete();
      throw 'Gagal menyimpan data user: $e';
    }
  }

  // Login dengan email dan password
  Future<Map<String, dynamic>> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      // 1. Login ke Firebase Auth
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Ambil data user dari database
      if (userCredential.user != null) {
        final userData = await _getUserData(userCredential.user!.uid);
        return {
          'user': userCredential.user,
          'role': userData['role'],
          'nama': userData['nama'],
        };
      }

      throw 'Login gagal: Data pengguna tidak ditemukan';
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Terjadi kesalahan saat login: $e';
    }
  }

  // Ambil data user dari database
  Future<Map<String, dynamic>> _getUserData(String uid) async {
    try {
      final snapshot = await _database.child('users').child(uid).get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      throw 'Data pengguna tidak ditemukan';
    } catch (e) {
      throw 'Gagal mengambil data user: $e';
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Gagal logout: $e';
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is logged in
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get user role
  Future<String?> getUserRole(String uid) async {
    try {
      final userData = await _getUserData(uid);
      return userData['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  // Handle Firebase Auth errors
  String _handleAuthError(FirebaseAuthException e) {
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
}
