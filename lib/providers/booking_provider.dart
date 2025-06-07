import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/doctor.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final BookingService _bookingService = BookingService();

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

    return _bookingService.getApprovedBookings();
  }

  // Stream untuk riwayat booking admin (ditolak)
  Stream<List<Booking>>? get rejectedBookings {
    final user = _authService.currentUser;
    if (user == null) return Stream.value([]);

    return _bookingService.getRejectedBookings();
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
        doctor: doctor,
        selectedDay: selectedDay!,
        selectedTime: selectedTime!,
        selectedDate: selectedDate!,
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
}
