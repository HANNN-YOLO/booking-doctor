import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Mendapatkan user saat ini
  User? get currentUser => _auth.currentUser;

  // Stream untuk memantau status autentikasi
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _getProfilePath(String role) {
    return role.toLowerCase() == 'admin' ? 'admin_profiles' : 'pasien_profiles';
  }

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
        final profilePath = _getProfilePath(role);
        await _database
            .ref()
            .child(profilePath)
            .child(userCredential.user!.uid)
            .set({
          'kunci': userCredential.user!.uid,
          'nama': name,
          'email': email,
          'role': role,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'profile_completed': true,
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
      // Cek di admin_profiles dulu
      final adminSnapshot =
          await _database.ref().child('admin_profiles').child(uid).get();
      if (adminSnapshot.exists) {
        return Map<String, dynamic>.from(adminSnapshot.value as Map);
      }

      // Kalau tidak ada, cek di pasien_profiles
      final patientSnapshot =
          await _database.ref().child('pasien_profiles').child(uid).get();
      if (patientSnapshot.exists) {
        return Map<String, dynamic>.from(patientSnapshot.value as Map);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Update profil user
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      final role = data['role'] ?? 'Pasien';
      final profilePath = _getProfilePath(role);
      data['updatedAt'] = DateTime.now().toIso8601String();
      await _database.ref().child(profilePath).child(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Cek apakah user adalah admin
  Future<bool> isAdmin(String uid) async {
    try {
      final snapshot =
          await _database.ref().child('admin_profiles').child(uid).get();
      return snapshot.exists;
    } catch (e) {
      return false;
    }
  }
}
