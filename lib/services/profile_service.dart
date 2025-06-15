import 'package:firebase_database/firebase_database.dart';
import '../models/daftar.dart';

class ProfileService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  String _getProfilePath(String role) {
    return role.toLowerCase() == 'admin' ? 'admin_profiles' : 'pasien_profiles';
  }

  // Membuat profil lengkap
  Future<void> createProfile(String uid, Daftar daftar) async {
    try {
      final profilePath = _getProfilePath(daftar.role ?? 'pasien');
      await _database.child(profilePath).child(uid).set({
        'kunci': uid,
        'nama': daftar.nama,
        'email': daftar.email,
        'nohp': daftar.nohp,
        'tgllahir': daftar.tgllahir?.toIso8601String(),
        'asal': daftar.asal,
        'alamat': daftar.alamat,
        'role': daftar.role,
        'profile_completed': true,
        'updated_at': DateTime.now().toIso8601String(),
        'gambar': daftar.gambar,
      });
    } catch (e) {
      throw 'Gagal membuat profil: $e';
    }
  }

  // Mengambil data profil
  Future<Map<String, dynamic>?> getProfile(String uid, {String? role}) async {
    try {
      if (role == null) {
        // Jika role tidak diketahui, cek di kedua lokasi
        final adminSnapshot =
            await _database.child('admin_profiles').child(uid).get();
        if (adminSnapshot.exists) {
          return Map<String, dynamic>.from(adminSnapshot.value as Map);
        }

        final patientSnapshot =
            await _database.child('pasien_profiles').child(uid).get();
        if (patientSnapshot.exists) {
          return Map<String, dynamic>.from(patientSnapshot.value as Map);
        }

        return null;
      }

      final profilePath = _getProfilePath(role);
      final snapshot = await _database.child(profilePath).child(uid).get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      throw 'Gagal mengambil profil: $e';
    }
  }

  // Update profil
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      final role = data['role'] ?? 'pasien';
      final profilePath = _getProfilePath(role);
      data['updated_at'] = DateTime.now().toIso8601String();
      await _database.child(profilePath).child(uid).update(data);
    } catch (e) {
      throw 'Gagal mengupdate profil: $e';
    }
  }

  // Cek status kelengkapan profil
  Future<bool> isProfileComplete(String uid, {String? role}) async {
    try {
      if (role == null) {
        // Cek di kedua lokasi
        final adminSnapshot = await _database
            .child('admin_profiles')
            .child(uid)
            .child('profile_completed')
            .get();
        if (adminSnapshot.exists && (adminSnapshot.value as bool)) {
          return true;
        }

        final patientSnapshot = await _database
            .child('pasien_profiles')
            .child(uid)
            .child('profile_completed')
            .get();
        return patientSnapshot.exists && (patientSnapshot.value as bool);
      }

      final profilePath = _getProfilePath(role);
      final snapshot = await _database
          .child(profilePath)
          .child(uid)
          .child('profile_completed')
          .get();
      return snapshot.exists && (snapshot.value as bool);
    } catch (e) {
      return false;
    }
  }

  // Stream untuk mendengarkan perubahan profil
  Stream<DatabaseEvent> profileStream(String uid, {String? role}) {
    if (role == null) {
      // Jika role tidak diketahui, gabungkan stream dari kedua lokasi
      return _database.child('admin_profiles').child(uid).onValue;
    }
    final profilePath = _getProfilePath(role);
    return _database.child(profilePath).child(uid).onValue;
  }
}
