import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/booking.dart';
import '../models/doctor.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Membuat booking baru
  Future<String> createBooking({
    required String userId,
    required Doctor doctor,
    required String selectedDay,
    required String selectedTime,
  }) async {
    try {
      // 1. Ambil data profil user dari Realtime Database
      final userSnapshot = await _database.ref(userId).get();
      if (!userSnapshot.exists) {
        throw Exception('Data profil tidak ditemukan');
      }

      final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
      final patientName = userData['name'] as String? ?? 'Pasien';

      // 2. Buat referensi dokumen baru di Firestore
      final bookingRef = _firestore.collection('booking').doc();

      // 3. Buat objek booking
      final booking = Booking(
        kunci: bookingRef.id,
        userId: userId,
        patientName: patientName,
        id_doctor: doctor.kunci,
        doctorName: doctor.name,
        specialty: doctor.specialty,
        selectedDay: selectedDay,
        selectedTime: selectedTime,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      // 4. Simpan booking ke Firestore
      await bookingRef.set(booking.toMap());

      // 5. Update status ketersediaan waktu dokter
      await _updateDoctorAvailability(
        doctorId: doctor.kunci,
        day: selectedDay,
        time: selectedTime,
        isBooked: true,
      );

      return bookingRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Update status ketersediaan waktu dokter
  Future<void> _updateDoctorAvailability({
    required String doctorId,
    required String day,
    required String time,
    required bool isBooked,
  }) async {
    final doctorRef = _firestore.collection('doctor').doc(doctorId);

    await _firestore.runTransaction((transaction) async {
      final doctorDoc = await transaction.get(doctorRef);
      if (!doctorDoc.exists) {
        throw Exception('Dokter tidak ditemukan');
      }

      final data = doctorDoc.data()!;
      final availableDays =
          List<Map<String, dynamic>>.from(data['availableDays']);

      for (var i = 0; i < availableDays.length; i++) {
        if (availableDays[i]['day'] == day) {
          final times = List<Map<String, dynamic>>.from(
              availableDays[i]['availableTimes']);
          for (var j = 0; j < times.length; j++) {
            if (times[j]['time'] == time) {
              times[j]['isBooked'] = isBooked;
              break;
            }
          }
          availableDays[i]['availableTimes'] = times;
          break;
        }
      }

      transaction.update(doctorRef, {'availableDays': availableDays});
    });
  }

  // Mendapatkan daftar booking pending untuk admin
  Stream<List<Booking>> getPendingBookings() {
    return _firestore
        .collection('booking')
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
        .collection('booking')
        .where('userId', isEqualTo: userId)
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
    final bookingRef = _firestore.collection('booking').doc(bookingId);

    await _firestore.runTransaction((transaction) async {
      final bookingDoc = await transaction.get(bookingRef);
      if (!bookingDoc.exists) {
        throw Exception('Booking tidak ditemukan');
      }

      transaction.update(bookingRef, {
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Menolak booking
  Future<void> rejectBooking(String bookingId, String reason) async {
    final bookingRef = _firestore.collection('booking').doc(bookingId);

    await _firestore.runTransaction((transaction) async {
      final bookingDoc = await transaction.get(bookingRef);
      if (!bookingDoc.exists) {
        throw Exception('Booking tidak ditemukan');
      }

      final bookingData = bookingDoc.data()!;

      // Reset ketersediaan waktu dokter
      await _updateDoctorAvailability(
        doctorId: bookingData['id_doctor'],
        day: bookingData['selectedDay'],
        time: bookingData['selectedTime'],
        isBooked: false,
      );

      transaction.update(bookingRef, {
        'status': 'rejected',
        'rejectionReason': reason,
        'rejectedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Mendapatkan semua booking yang disetujui (untuk admin)
  Stream<List<Booking>> getApprovedBookings() {
    return _firestore
        .collection('booking')
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
