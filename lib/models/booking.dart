import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime bookingDate;
  final String time;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.bookingDate,
    required this.time,
    required this.status,
    required this.createdAt,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'time': time,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
