import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime bookingDate;
  final String time;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final DateTime createdAt;
  // Field baru
  final String patientName;
  final int? patientAge; // Umur bisa null
  final String doctorName;
  final String doctorSpecialty;
  final String bookingDay; // e.g., "Senin"
  final String? cancellationReason; // Alasan pembatalan

  Booking({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.bookingDate,
    required this.time,
    required this.status,
    required this.createdAt,
    // Tambahkan parameter constructor baru
    required this.patientName,
    this.patientAge, // Opsional di constructor jika nullable
    required this.doctorName,
    required this.doctorSpecialty,
    required this.bookingDay,
    this.cancellationReason, // Tambahkan di constructor
  });

  factory Booking.fromMap(Map<String, dynamic> data, String documentId) {
    return Booking(
      id: documentId,
      doctorId: data['doctorId'] ?? '',
      patientId: data['patientId'] ?? '',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      // Ambil data untuk field baru
      patientName: data['patientName'] ?? '',
      patientAge: data['patientAge'] as int?, // Casting sebagai int?
      doctorName: data['doctorName'] ?? '',
      doctorSpecialty: data['doctorSpecialty'] ?? '',
      bookingDay: data['bookingDay'] ?? '',
      cancellationReason:
          data['cancellationReason'] as String?, // Ambil dari map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'time': time,
      'status': status,
      'createdAt': Timestamp.fromDate(
          createdAt), // Sebaiknya gunakan FieldValue.serverTimestamp() saat create baru
      // Tambahkan field baru ke map
      'patientName': patientName,
      'patientAge': patientAge,
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'bookingDay': bookingDay,
      'cancellationReason': cancellationReason, // Tambahkan ke map
    };
  }
}
