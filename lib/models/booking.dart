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
  final DateTime selectedDate; // Tanggal yang dipilih untuk booking
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
    required this.selectedDate,
    this.approvedAt,
    this.rejectedAt,
    this.rejectionReason,
  });

  factory Booking.fromMap(Map<String, dynamic> data, String documentId) {
    // Fungsi helper untuk mengkonversi string hari ke DateTime
    DateTime getDateFromDay(String day) {
      final Map<String, int> dayToNumber = {
        'Minggu': 7,
        'Senin': 1,
        'Selasa': 2,
        'Rabu': 3,
        'Kamis': 4,
        'Jumat': 5,
        'Sabtu': 6,
      };

      final now = DateTime.now();
      final dayNumber = dayToNumber[day] ?? 1;
      final currentDayNumber = now.weekday;

      // Hitung selisih hari
      int daysToAdd = dayNumber - currentDayNumber;
      if (daysToAdd <= 0) {
        daysToAdd += 7; // Tambah 7 hari jika hari yang dipilih sudah lewat
      }

      // Kembalikan tanggal yang sesuai
      return DateTime(
        now.year,
        now.month,
        now.day + daysToAdd,
      );
    }

    // Ambil selectedDate dari Firestore, jika null gunakan helper function
    DateTime bookingDate;
    if (data['selectedDate'] != null) {
      bookingDate = (data['selectedDate'] as Timestamp).toDate();
    } else {
      // Jika tidak ada selectedDate, generate dari selectedDay
      final selectedDay = data['selectedDay'] as String? ?? 'Senin';
      bookingDate = getDateFromDay(selectedDay);
    }

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
      selectedDate: bookingDate,
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
      'selectedDate': Timestamp.fromDate(selectedDate),
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'rejectedAt': rejectedAt != null ? Timestamp.fromDate(rejectedAt!) : null,
      'rejectionReason': rejectionReason,
    };
  }
}
