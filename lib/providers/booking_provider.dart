import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';
import '../models/doctor.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State untuk form booking
  DateTime? selectedDate;
  String? selectedDay;
  String? selectedTime;

  // Controllers untuk form
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  // Fungsi untuk mendapatkan nama hari dari tanggal
  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> selectDate(BuildContext context, Doctor doctor) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      selectableDayPredicate: (DateTime date) {
        // Cek apakah hari tersebut tersedia di jadwal dokter
        String dayName = _getDayName(date);
        return doctor.availableDays.any((day) => day.day == dayName);
      },
    );

    if (picked != null) {
      selectedDate = picked;
      selectedDay = _getDayName(picked);
      dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      selectedTime = null; // Reset waktu yang dipilih
      timeController.clear();
      notifyListeners();
    }
  }

  // Fungsi untuk mendapatkan waktu yang tersedia
  List<String> getAvailableTimesForDay(Doctor doctor) {
    if (selectedDay == null) return [];

    final daySchedule = doctor.availableDays.firstWhere(
        (day) => day.day == selectedDay,
        orElse: () => AvailableDay(day: '', availableTimes: []));

    return daySchedule.availableTimes
        .where((time) => !time.isBooked)
        .map((time) => time.time)
        .toList();
  }

  // Fungsi untuk membuat booking
  Future<bool> createBooking(Doctor doctor, BuildContext context) async {
    try {
      if (selectedDay == null || selectedTime == null) {
        throw Exception('Pilih hari dan waktu terlebih dahulu');
      }

      // Buat dokumen booking baru
      final bookingRef = _firestore.collection('booking').doc();
      final booking = Booking(
        kunci: bookingRef.id,
        id_doctor: doctor.kunci,
        selectedDay: selectedDay!,
        selectedTime: selectedTime!,
        status: 'pending',
        createdAt: DateTime.now(),
        doctorName: doctor.name,
        specialty: doctor.specialty,
      );

      // Simpan booking
      await bookingRef.set(booking.toMap());

      // Update status waktu dokter menjadi booked
      await _firestore.collection('doctor').doc(doctor.kunci).update({
        'availableDays': doctor.availableDays.map((day) {
          if (day.day == selectedDay) {
            final updatedTimes = day.availableTimes.map((time) {
              if (time.time == selectedTime) {
                return {'time': time.time, 'isBooked': true};
              }
              return {'time': time.time, 'isBooked': time.isBooked};
            }).toList();
            return {
              'day': day.day,
              'availableTimes': updatedTimes,
            };
          }
          return {
            'day': day.day,
            'availableTimes': day.availableTimes
                .map((t) => {
                      'time': t.time,
                      'isBooked': t.isBooked,
                    })
                .toList(),
          };
        }).toList(),
      });

      // Reset form
      resetForm();
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return false;
    }
  }

  // Reset form
  void resetForm() {
    selectedDate = null;
    selectedDay = null;
    selectedTime = null;
    dateController.clear();
    timeController.clear();
    notifyListeners();
  }

  // Dispose
  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }
}
