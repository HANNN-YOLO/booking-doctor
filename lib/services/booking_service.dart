// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../models/booking.dart';
// import '../models/doctor.dart';

// class BookingService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseDatabase _database = FirebaseDatabase.instance;

//   // Membuat booking baru
//   Future<String> createBooking({
//     required String userId,
//     required String doctorId,
//     required DateTime bookingDate,
//     required String time,
//   }) async {
//     try {
//       // 1. Ambil data profil user dari Realtime Database
//       // final userSnapshot = await _database.ref(userId).get();
//       // if (!userSnapshot.exists) {
//       //   throw Exception('Data profil tidak ditemukan');
//       // }

//       // 2. Buat referensi dokumen baru di Firestore
//       final bookingRef = _firestore.collection('bookings').doc();

//       // 3. Buat data booking
//       final bookingData = {
//         'doctorId': doctorId,
//         'patientId': userId,
//         'bookingDate': Timestamp.fromDate(DateTime(
//           bookingDate.year,
//           bookingDate.month,
//           bookingDate.day,
//         )),
//         'time': time,
//         'status': 'pending',
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       // 4. Simpan booking ke Firestore
//       await bookingRef.set(bookingData);

//       return bookingRef.id;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Mendapatkan daftar booking pending untuk admin
//   Stream<List<Booking>> getPendingBookings() {
//     return _firestore
//         .collection('bookings')
//         .where('status', isEqualTo: 'pending')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) => Booking.fromMap(doc.data(), doc.id))
//           .toList();
//     });
//   }

//   // Mendapatkan booking berdasarkan status untuk user tertentu
//   Stream<List<Booking>> getUserBookings(String userId, String status) {
//     return _firestore
//         .collection('bookings')
//         .where('patientId', isEqualTo: userId)
//         .where('status', isEqualTo: status)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) => Booking.fromMap(doc.data(), doc.id))
//           .toList();
//     });
//   }

//   // Menyetujui booking
//   Future<void> approveBooking(String bookingId) async {
//     await _firestore.collection('bookings').doc(bookingId).update({
//       'status': 'confirmed',
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // Menolak booking
//   Future<void> rejectBooking(String bookingId, String reason) async {
//     await _firestore.collection('bookings').doc(bookingId).update({
//       'status': 'cancelled',
//       'cancellationReason': reason,
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // Mendapatkan semua booking yang disetujui (untuk admin)
//   Stream<List<Booking>> getConfirmedBookings() {
//     return _firestore
//         .collection('bookings')
//         .where('status', isEqualTo: 'confirmed')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) => Booking.fromMap(doc.data(), doc.id))
//           .toList();
//     });
//   }

//   // Mendapatkan semua booking yang ditolak (untuk admin)
//   Stream<List<Booking>> getCancelledBookings() {
//     return _firestore
//         .collection('bookings')
//         .where('status', isEqualTo: 'cancelled')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) => Booking.fromMap(doc.data(), doc.id))
//           .toList();
//     });
//   }

//   // Mendapatkan notifikasi booking (confirmed dan cancelled)
//   Stream<List<Booking>> getUserNotificationsWithStatus(String userId) {
//     return _firestore
//         .collection('bookings')
//         .where('patientId', isEqualTo: userId)
//         .where('status', whereIn: ['confirmed', 'cancelled'])
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs
//               .map((doc) => Booking.fromMap(doc.data(), doc.id))
//               .toList();
//         });
//   }

//   // Check availability of a specific time slot
//   Future<bool> checkAvailability(
//       String doctorId, DateTime date, String time) async {
//     final querySnapshot = await _firestore
//         .collection('bookings')
//         .where('doctorId', isEqualTo: doctorId)
//         .where('bookingDate',
//             isEqualTo: Timestamp.fromDate(DateTime(
//               date.year,
//               date.month,
//               date.day,
//             )))
//         .where('time', isEqualTo: time)
//         .where('status', whereIn: ['pending', 'confirmed']).get();

//     return querySnapshot.docs.isEmpty;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
// FirebaseDatabase import is removed as _database is no longer used.
// import 'package:firebase_database/firebase_database.dart';
import '../models/booking.dart';
// import '../models/doctor.dart'; // This import is unused and has been removed.

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseDatabase _database = FirebaseDatabase.instance; // Removed

  // Membuat booking baru
  Future<String> createBooking({
    required String userId,
    required String doctorId,
    required DateTime bookingDate,
    required String time,
    // Parameter baru
    required String patientName,
    int? patientAge,
    required String doctorName,
    required String doctorSpecialty,
    required String bookingDay,
  }) async {
    try {
      // Buat referensi dokumen baru di Firestore
      final bookingRef = _firestore.collection('bookings').doc();

      // Buat data booking
      final bookingData = {
        'doctorId': doctorId,
        'patientId': userId,
        'bookingDate': Timestamp.fromDate(DateTime(
          bookingDate.year,
          bookingDate.month,
          bookingDate.day,
        )),
        'time': time,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        // Tambahkan field baru ke data yang akan disimpan
        'patientName': patientName,
        'patientAge': patientAge,
        'doctorName': doctorName,
        'doctorSpecialty': doctorSpecialty,
        'bookingDay': bookingDay,
      };

      // Simpan booking ke Firestore
      await bookingRef.set(bookingData);

      return bookingRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Mendapatkan daftar booking pending untuk admin
  Stream<List<Booking>> getPendingBookings() {
    return _firestore
        .collection('bookings')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Mendapatkan booking berdasarkan status untuk user tertentu
  Stream<List<Booking>> getUserBookings(String userId, String status) {
    return _firestore
        .collection('bookings')
        .where('patientId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Menyetujui booking
  Future<void> approveBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': 'confirmed',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Menolak booking
  Future<void> rejectBooking(String bookingId, String reason) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': 'cancelled',
      'cancellationReason': reason,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Mendapatkan semua booking yang disetujui (untuk admin)
  Stream<List<Booking>> getConfirmedBookings() {
    return _firestore
        .collection('bookings')
        .where('status', isEqualTo: 'confirmed')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Mendapatkan semua booking yang ditolak (untuk admin)
  Stream<List<Booking>> getCancelledBookings() {
    return _firestore
        .collection('bookings')
        .where('status', isEqualTo: 'cancelled')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Mendapatkan notifikasi booking (confirmed dan cancelled)
  Stream<List<Booking>> getUserNotificationsWithStatus(String userId) {
    return _firestore
        .collection('bookings')
        .where('patientId', isEqualTo: userId)
        .where('status', whereIn: ['confirmed', 'cancelled'])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Booking.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Check availability of a specific time slot
  Future<bool> checkAvailability(
      String doctorId, DateTime date, String time) async {
    final querySnapshot = await _firestore
        .collection('bookings')
        .where('doctorId', isEqualTo: doctorId)
        .where('bookingDate',
            isEqualTo: Timestamp.fromDate(DateTime(
              date.year,
              date.month,
              date.day,
            )))
        .where('time', isEqualTo: time)
        .where('status', whereIn: ['pending', 'confirmed']).get();

    return querySnapshot.docs.isEmpty;
  }
}
