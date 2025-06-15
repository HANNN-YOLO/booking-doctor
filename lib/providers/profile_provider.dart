import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/daftar.dart';
import '../services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Map<String, dynamic>? _profileData;
  bool _isLoading = false;
  String? _error;
  bool _isProfileComplete = false;
  String? _role;
  List<Daftar> _patients = [];

  // Getters
  Map<String, dynamic>? get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isProfileComplete => _isProfileComplete;
  String? get role => _role;
  List<Daftar> get patients => _patients;

  int? _calculateAge(String? birthDateString) {
    // Log the input birthDateString for diagnostic purposes
    print(
        '[ProfileProvider] Attempting to calculate age for birthDateString: "$birthDateString"');

    if (birthDateString == null || birthDateString.isEmpty) {
      print(
          '[ProfileProvider] birthDateString is null or empty. Returning null for age.');
      return null;
    }

    DateTime birthDate;
    try {
      // Attempt to parse the date. This handles "YYYY-MM-DD" and "YYYY-MM-DDTHH:mm:ss..."
      // If 'T' is present, split and take the date part. Otherwise, parse directly.
      if (birthDateString.contains('T')) {
        final datePart = birthDateString.split('T').first;
        birthDate = DateTime.parse(datePart);
      } else {
        birthDate = DateTime.parse(birthDateString);
      }
    } catch (e) {
      print(
          '[ProfileProvider] Error parsing birthDateString "$birthDateString": $e. Returning null for age.');
      return null;
    }

    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    print(
        '[ProfileProvider] Calculated age: $age for birthDateString: "$birthDateString"');
    return age;
  }

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

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  // Load profile data
  Future<void> loadProfile(String uid, BuildContext context) async {
    try {
      _setLoading(true);
      _setError(null);
      notifyListeners();

      _profileData = await _profileService.getProfile(uid, role: _role);
      if (_profileData != null) {
        _role = _profileData!['role'];
        final birthDateString = _profileData!['tgllahir'] as String?;
        // _calculateAge will return null if birthDateString is invalid or missing
        _profileData!['usia'] = _calculateAge(birthDateString);
        _isProfileComplete =
            await _profileService.isProfileComplete(uid, role: _role);
        pemberitahuan('Data profil berhasil dimuat', context);
      }
    } catch (e) {
      _setError(e.toString());
      pemberitahuanError('Gagal memuat profil: ${e.toString()}', context);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Create new profile
  Future<bool> createProfile(
      String uid, Daftar daftar, BuildContext context) async {
    try {
      _setLoading(true);
      _setError(null);
      notifyListeners();

      await _profileService.createProfile(uid, daftar);
      _role = daftar.role;
      await loadProfile(uid, context);
      pemberitahuan('Profil berhasil dibuat', context);
      return true;
    } catch (e) {
      _setError(e.toString());
      pemberitahuanError('Gagal membuat profil: ${e.toString()}', context);
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Update profile
  Future<bool> updateProfile(
      String uid, Map<String, dynamic> data, BuildContext context) async {
    try {
      _setLoading(true);
      _setError(null);
      notifyListeners();

      if (_role != null) {
        data['role'] = _role;
      }
      await _profileService.updateProfile(uid, data);
      await loadProfile(uid, context);
      pemberitahuan('Profil berhasil diperbarui', context);
      return true;
    } catch (e) {
      _setError(e.toString());
      pemberitahuanError('Gagal memperbarui profil: ${e.toString()}', context);
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Listen to profile changes
  void listenToProfile(String uid) {
    _profileService.profileStream(uid, role: _role).listen(
        (DatabaseEvent event) {
      if (event.snapshot.exists) {
        _profileData = Map<String, dynamic>.from(event.snapshot.value as Map);
        if (_profileData != null) {
          _role = _profileData!['role'];
          final birthDateString = _profileData!['tgllahir'] as String?;
          // _calculateAge will return null if birthDateString is invalid or missing
          _profileData!['usia'] = _calculateAge(birthDateString);
        }
        notifyListeners();
      }
    }, onError: (error) {
      _setError('Error listening to profile changes: $error');
    });
  }

  // Clear profile data (when logging out)
  void clearProfile() {
    _profileData = null;
    _isProfileComplete = false;
    _error = null;
    _role = null;
    notifyListeners();
  }

  Future<void> updateProfileInDatabase(
      String userId, Map<String, dynamic> updates) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_role != null) {
        updates['role'] = _role;
      }

      final profilePath = _role?.toLowerCase() == 'admin'
          ? 'admin_profiles'
          : 'pasien_profiles';
      await _database.child(profilePath).child(userId).update(updates);

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      throw e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<Daftar?> getProfileFromDatabase(String userId) async {
    try {
      _setLoading(true);
      _setError(null);

      final profilePath = _role?.toLowerCase() == 'admin'
          ? 'admin_profiles'
          : 'pasien_profiles';
      final snapshot = await _database.child(profilePath).child(userId).get();

      if (snapshot.exists) {
        return Daftar.fromJson(
          userId,
          Map<String, dynamic>.from(snapshot.value as Map),
        );
      }
      return null;
    } catch (e) {
      _setError(e.toString());
      throw e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Get all patients
  Future<void> getPatients() async {
    try {
      _setLoading(true);
      _setError(null);

      final snapshot = await _database.child('pasien_profiles').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        _patients = data.entries.map((entry) {
          final patientData = Map<String, dynamic>.from(entry.value as Map);
          patientData['id'] = entry.key;
          return Daftar.fromJson(entry.key, patientData);
        }).toList();
      } else {
        _patients = [];
      }
    } catch (e) {
      _setError(e.toString());
      throw e.toString();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Get patient by ID
  Future<Map<String, dynamic>?> getPatientById(String patientId) async {
    try {
      _setLoading(true);
      _setError(null);

      final snapshot =
          await _database.child('pasien_profiles').child(patientId).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data['id'] = patientId;
        return data;
      }
      return null;
    } catch (e) {
      _setError(e.toString());
      throw e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update patient
  Future<void> updatePatient(
      String patientId, Map<String, dynamic> updates) async {
    try {
      _setLoading(true);
      _setError(null);

      await _database.child('pasien_profiles').child(patientId).update(updates);
      await getPatients(); // Refresh the list
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      throw e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Delete patient
  Future<void> deletePatient(String patientId) async {
    try {
      _setLoading(true);
      _setError(null);

      await _database.child('pasien_profiles').child(patientId).remove();
      await getPatients(); // Refresh the list
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      throw e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Get patient by email (untuk struktur flat)
  Future<Map<String, dynamic>?> getPatientByEmail(String email) async {
    try {
      _setLoading(true);
      _setError(null);

      final snapshot = await _database.child('pasien_profiles').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        for (var value in data.values) {
          if (value is Map && value['email'] == email) {
            return Map<String, dynamic>.from(value);
          }
        }
      }
      return null;
    } catch (e) {
      _setError(e.toString());
      throw e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Map<String, dynamic>>> getPatientsByAdminId(
      String adminId) async {
    try {
      final patientsSnapshot = await _database.child('daftar').get();
      List<Map<String, dynamic>> patientsList = [];

      if (patientsSnapshot.value != null) {
        final patients = patientsSnapshot.value as Map<dynamic, dynamic>;
        patients.forEach((key, value) {
          if (value['kunci'] == adminId) {
            patientsList.add({
              ...value,
              'id': key,
            });
          }
        });
      }

      return patientsList;
    } catch (e) {
      print('Error getting patients data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllPatientsList() async {
    final snapshot = await _database.child('pasien_profiles').get();
    List<Map<String, dynamic>> patientsList = [];
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        final patientData = Map<String, dynamic>.from(value as Map);
        patientData['id'] = key;
        patientsList.add(patientData);
      });
    }
    return patientsList;
  }
}
