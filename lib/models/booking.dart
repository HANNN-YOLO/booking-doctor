import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String kunci; // ID dokumen di Firestore
  final String userId; // UID dari Firebase Auth
  final String patientName; // Nama pasien dari Realtime DB
  final String id_doctor; // ID dokter
  final String doctorName; // Nama dokter
  final String specialty; // Spesialis dokter
  final String selectedDay; // Hari yang dipilih
  final String selectedTime; // Waktu yang dipilih
  final String status; // pending/approved/rejected
  final DateTime createdAt; // Waktu pembuatan booking
  final DateTime? approvedAt; // Waktu disetujui (jika approved)
  final DateTime? rejectedAt; // Waktu ditolak (jika rejected)
  final String? rejectionReason; // Alasan penolakan (jika rejected)

  Booking({
    required this.kunci,
    required this.userId,
    required this.patientName,
    required this.id_doctor,
    required this.doctorName,
    required this.specialty,
    required this.selectedDay,
    required this.selectedTime,
    required this.status,
    required this.createdAt,
    this.approvedAt,
    this.rejectedAt,
    this.rejectionReason,
  });

  factory Booking.fromMap(Map<String, dynamic> data, String documentId) {
    return Booking(
      kunci: documentId,
      userId: data['userId'] ?? '',
      patientName: data['patientName'] ?? '',
      id_doctor: data['id_doctor'] ?? '',
      doctorName: data['doctorName'] ?? '',
      specialty: data['specialty'] ?? '',
      selectedDay: data['selectedDay'] ?? '',
      selectedTime: data['selectedTime'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      approvedAt: data['approvedAt'] != null
          ? (data['approvedAt'] as Timestamp).toDate()
          : null,
      rejectedAt: data['rejectedAt'] != null
          ? (data['rejectedAt'] as Timestamp).toDate()
          : null,
      rejectionReason: data['rejectionReason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'patientName': patientName,
      'id_doctor': id_doctor,
      'doctorName': doctorName,
      'specialty': specialty,
      'selectedDay': selectedDay,
      'selectedTime': selectedTime,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'rejectedAt': rejectedAt != null ? Timestamp.fromDate(rejectedAt!) : null,
      'rejectionReason': rejectionReason,
    };
  }
}
