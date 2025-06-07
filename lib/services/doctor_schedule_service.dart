import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';

class DoctorScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mendapatkan jadwal dokter untuk minggu tertentu
  Future<List<AvailableTime>> getDoctorScheduleForWeek(
    String doctorId,
    DateTime weekOf,
  ) async {
    try {
      final docSnapshot =
          await _firestore.collection('doctors').doc(doctorId).get();
      if (!docSnapshot.exists) {
        throw Exception('Dokter tidak ditemukan');
      }

      final doctorData = Doctor.fromMap(
        docSnapshot.data() as Map<String, dynamic>,
        docSnapshot.id,
      );

      // Gabungkan semua jadwal yang tersedia dari setiap hari
      List<AvailableTime> availableSlots = [];
      for (var day in doctorData.availableDays) {
        availableSlots.addAll(day.getAvailableTimesForWeek(weekOf));
      }

      // Urutkan berdasarkan tanggal dan waktu
      availableSlots.sort((a, b) {
        int dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;
        return a.time.compareTo(b.time);
      });

      return availableSlots;
    } catch (e) {
      throw Exception('Gagal mendapatkan jadwal: $e');
    }
  }

  // Memeriksa ketersediaan slot waktu tertentu
  Future<bool> isTimeSlotAvailable(
    String doctorId,
    DateTime date,
    String time,
  ) async {
    try {
      final slots = await getDoctorScheduleForWeek(doctorId, date);
      return slots.any((slot) =>
          slot.date.year == date.year &&
          slot.date.month == date.month &&
          slot.date.day == date.day &&
          slot.time == time &&
          !slot.isBooked);
    } catch (e) {
      throw Exception('Gagal memeriksa ketersediaan: $e');
    }
  }

  // Membuat booking untuk slot waktu tertentu
  Future<void> bookTimeSlot(
    String doctorId,
    String patientId,
    DateTime date,
    String time,
  ) async {
    final isAvailable = await isTimeSlotAvailable(doctorId, date, time);
    if (!isAvailable) {
      throw Exception('Slot waktu tidak tersedia');
    }

    try {
      // Update status booking di Firestore
      await _firestore.collection('doctors').doc(doctorId).update({
        'availableDays': FieldValue.arrayUnion([
          {
            'date': Timestamp.fromDate(date),
            'time': time,
            'isBooked': true,
            'patientId': patientId,
          }
        ])
      });
    } catch (e) {
      throw Exception('Gagal melakukan booking: $e');
    }
  }
}
