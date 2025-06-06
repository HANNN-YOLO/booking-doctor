import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String kunci;
  final String id_doctor;
  final String selectedDay;
  final String selectedTime;
  final String status; // pending, confirmed, cancelled
  final DateTime createdAt;
  final String doctorName; // Nama dokter untuk referensi
  final String specialty; // Spesialisasi dokter untuk referensi

  Booking({
    required this.kunci,
    required this.id_doctor,
    required this.selectedDay,
    required this.selectedTime,
    required this.status,
    required this.createdAt,
    required this.doctorName,
    required this.specialty,
  });

  factory Booking.fromMap(Map<String, dynamic> data, String documentId) {
    return Booking(
      kunci: documentId,
      id_doctor: data['id_doctor'] ?? '',
      selectedDay: data['selectedDay'] ?? '',
      selectedTime: data['selectedTime'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      doctorName: data['doctorName'] ?? '',
      specialty: data['specialty'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kunci': kunci,
      'id_doctor': id_doctor,
      'selectedDay': selectedDay,
      'selectedTime': selectedTime,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'doctorName': doctorName,
      'specialty': specialty,
    };
  }
}
