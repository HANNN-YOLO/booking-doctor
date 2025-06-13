import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking.dart';
import '../models/doctor.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';

class BookingProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final BookingService _bookingService = BookingService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // State untuk form booking
  DateTime? selectedDate;
  String? selectedDay;
  String? selectedTime;

  // Controllers untuk form
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  // Stream untuk admin
  Stream<List<Booking>>? get pendingBookings {
    final user = _authService.currentUser;
    if (user == null) return Stream.value([]);

    return _bookingService.getPendingBookings();
  }

  // Stream untuk riwayat booking admin (disetujui)
  Stream<List<Booking>>? get approvedBookings {
    final user = _authService.currentUser;
    if (user == null) return Stream.value([]);

    return _bookingService.getConfirmedBookings();
  }

  // Stream untuk riwayat booking admin (ditolak)
  Stream<List<Booking>>? get rejectedBookings {
    final user = _authService.currentUser;
    if (user == null) return Stream.value([]);

    return _bookingService.getCancelledBookings();
  }

  BookingProvider() {
    _initializeStreams();
  }

  void _initializeStreams() {
    final user = _authService.currentUser;
    if (user != null) {
      notifyListeners();
    }
  }

  // Reset form booking
  void resetForm() {
    selectedDate = null;
    selectedDay = null;
    selectedTime = null;
    dateController.clear();
    timeController.clear();
    notifyListeners();
  }

  // Konversi nama hari
  String getDayName(DateTime date) {
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    return days[date.weekday % 7];
  }

  // Membuat booking baru
  Future<bool> createBooking(Doctor doctor, BuildContext context) async {
    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('Anda harus login terlebih dahulu');
      }

      if (selectedDay == null || selectedTime == null || selectedDate == null) {
        throw Exception('Pilih tanggal, hari dan waktu terlebih dahulu');
      }

      await _bookingService.createBooking(
        userId: user.uid,
        doctorId: doctor.kunci,
        bookingDate: selectedDate!,
        time: selectedTime!,
      );

      resetForm();
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return false;
    }
  }

  // Menyetujui booking
  Future<bool> approveBooking(String bookingId, BuildContext context) async {
    try {
      await _bookingService.approveBooking(bookingId);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return false;
    }
  }

  // Menolak booking
  Future<bool> rejectBooking(
      String bookingId, String reason, BuildContext context) async {
    try {
      await _bookingService.rejectBooking(bookingId, reason);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return false;
    }
  }

  // Mendapatkan booking user berdasarkan status
  Stream<List<Booking>> getUserBookings(String status) {
    final user = _authService.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _bookingService.getUserBookings(user.uid, status);
  }

  // Mendapatkan notifikasi booking
  Stream<List<Booking>> getUserNotifications() {
    final user = _authService.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    // Menggabungkan stream approved dan rejected
    return _bookingService.getUserNotificationsWithStatus(user.uid);
  }

  // Check if a specific date and time slot is available
  Future<bool> checkAvailability(
      String doctorId, DateTime date, String time) async {
    return _bookingService.checkAvailability(doctorId, date, time);
  }

  // Get bookings for a specific doctor
  Stream<List<Booking>> getBookingsByDoctor(String doctorId) {
    return _firestore
        .collection('bookings')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('bookingDate')
        .orderBy('time')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get bookings for a specific patient
  Stream<List<Booking>> getBookingsByPatient(String patientId) {
    return _firestore
        .collection('bookings')
        .where('patientId', isEqualTo: patientId)
        .orderBy('bookingDate')
        .orderBy('time')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status,
    });
    notifyListeners();
  }

  // Get pending bookings for current patient
  Stream<List<Booking>> getCurrentUserBookings() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User tidak terautentikasi');
    }

    return _bookingService.getUserBookings(currentUser.uid, 'pending');
  }

  // Get confirmed bookings for current patient
  Stream<List<Booking>> getCurrentUserConfirmedBookings() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User tidak terautentikasi');
    }

    return _bookingService.getUserBookings(currentUser.uid, 'confirmed');
  }

  // Get cancelled bookings for current patient
  Stream<List<Booking>> getCurrentUserCancelledBookings() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User tidak terautentikasi');
    }

    return _bookingService.getUserBookings(currentUser.uid, 'cancelled');
  }

  // Get notifications for current patient
  Stream<List<Booking>> getCurrentUserNotifications() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User tidak terautentikasi');
    }

    return _bookingService.getUserNotificationsWithStatus(currentUser.uid);
  }

  // Admin methods
  Stream<List<Booking>> getPendingBookings() {
    return _bookingService.getPendingBookings();
  }

  Stream<List<Booking>> getConfirmedBookings() {
    return _bookingService.getConfirmedBookings();
  }

  Stream<List<Booking>> getCancelledBookings() {
    return _bookingService.getCancelledBookings();
  }
}
