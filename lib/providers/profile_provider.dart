import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/daftar.dart';
import '../services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  Map<String, dynamic>? _profileData;
  bool _isLoading = false;
  String? _error;
  bool _isProfileComplete = false;

  // Getters
  Map<String, dynamic>? get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isProfileComplete => _isProfileComplete;

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

  // Load profile data
  Future<void> loadProfile(String uid, BuildContext context) async {
    try {
      _isLoading = true;
      _setError(null);
      notifyListeners();

      _profileData = await _profileService.getProfile(uid);
      _isProfileComplete = await _profileService.isProfileComplete(uid);

      if (_profileData != null) {
        pemberitahuan('Data profil berhasil dimuat', context);
      }
    } catch (e) {
      _setError(e.toString());
      pemberitahuanError('Gagal memuat profil: ${e.toString()}', context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new profile
  Future<bool> createProfile(
      String uid, Daftar daftar, BuildContext context) async {
    try {
      _isLoading = true;
      _setError(null);
      notifyListeners();

      await _profileService.createProfile(uid, daftar);
      await loadProfile(uid, context);
      pemberitahuan('Profil berhasil dibuat', context);
      return true;
    } catch (e) {
      _setError(e.toString());
      pemberitahuanError('Gagal membuat profil: ${e.toString()}', context);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update profile
  Future<bool> updateProfile(
      String uid, Map<String, dynamic> data, BuildContext context) async {
    try {
      _isLoading = true;
      _setError(null);
      notifyListeners();

      await _profileService.updateProfile(uid, data);
      await loadProfile(uid, context);
      pemberitahuan('Profil berhasil diperbarui', context);
      return true;
    } catch (e) {
      _setError(e.toString());
      pemberitahuanError('Gagal memperbarui profil: ${e.toString()}', context);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Listen to profile changes
  void listenToProfile(String uid) {
    _profileService.profileStream(uid).listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        _profileData = Map<String, dynamic>.from(event.snapshot.value as Map);
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
    notifyListeners();
  }
}
