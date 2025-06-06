import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Mendapatkan user saat ini
  User? get currentUser => _auth.currentUser;

  // Stream untuk memantau status autentikasi
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registrasi user baru
  Future<UserCredential> registerUser({
    required String email,
    required String password,
    required String name,
    String role = 'Pasien', // Default role
  }) async {
    try {
      // 1. Buat akun di Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Simpan data profil di Realtime Database
      if (userCredential.user != null) {
        await _database.ref(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'role': role,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Login user
  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Mendapatkan data profil user
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final snapshot = await _database.ref(uid).get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Update profil user
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now().toIso8601String();
      await _database.ref(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Cek apakah user adalah admin
  Future<bool> isAdmin(String uid) async {
    try {
      final snapshot = await _database.ref(uid).child('role').get();
      return snapshot.exists && snapshot.value == 'Admin';
    } catch (e) {
      return false;
    }
  }
}
