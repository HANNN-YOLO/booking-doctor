import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Booking {
  final String kunci;
  final int id_booking;
  final int id_doctor;
  final DateTime bookingDate;
  final TimeOfDay bookingTime;

  Booking({
    required this.kunci,
    required this.id_booking,
    required this.id_doctor,
    required this.bookingDate,
    required this.bookingTime,
  });

  factory Booking.fromMap(Map<String, dynamic> data, String documentId) {
    // Ambil Timestamp dari Firestore dan konversi ke TimeOfDay
    final timestamp = data['bookingTime'] as Timestamp;
    final time = timestamp.toDate();

    return Booking(
      kunci: data['kunci'],
      id_booking: data['id_booking'] ?? 0,
      id_doctor: data['id_doctor'] ?? 0,
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      bookingTime: TimeOfDay(hour: time.hour, minute: time.minute),
    );
  }

  Map<String, dynamic> toMap() {
    // Gabungkan tanggal & waktu ke DateTime untuk simpan ke Firestore
    final fullDateTime = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      bookingTime.hour,
      bookingTime.minute,
    );

    return {
      'kunci': kunci,
      'id_booking': id_booking,
      'id_doctor': id_doctor,
      'bookingDate': bookingDate,
      'bookingTime': fullDateTime,
    };
  }
}
