import 'package:firebase_database/firebase_database.dart';
import '../models/daftar.dart';

class ProfileService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Membuat profil lengkap pasien
  Future<void> createProfile(String uid, Daftar daftar) async {
    try {
      await _database.child('pasien_profiles').child(uid).set({
        'nama': daftar.nama,
        'email': daftar.email,
        'nohp': daftar.nohp,
        'tgllahir': daftar.tgllahir?.toIso8601String(),
        'asal': daftar.asal,
        'alamat': daftar.alamat,
        'profile_completed': true,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw 'Gagal membuat profil: $e';
    }
  }

  // Mengambil data profil pasien
  Future<Map<String, dynamic>?> getProfile(String uid) async {
    try {
      final snapshot =
          await _database.child('pasien_profiles').child(uid).get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      throw 'Gagal mengambil profil: $e';
    }
  }

  // Update profil pasien
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      await _database.child('pasien_profiles').child(uid).update(data);
    } catch (e) {
      throw 'Gagal mengupdate profil: $e';
    }
  }

  // Cek status kelengkapan profil
  Future<bool> isProfileComplete(String uid) async {
    try {
      final snapshot = await _database
          .child('pasien_profiles')
          .child(uid)
          .child('profile_completed')
          .get();
      return snapshot.exists && (snapshot.value as bool);
    } catch (e) {
      return false;
    }
  }

  // Stream untuk mendengarkan perubahan profil
  Stream<DatabaseEvent> profileStream(String uid) {
    return _database.child('pasien_profiles').child(uid).onValue;
  }
}
