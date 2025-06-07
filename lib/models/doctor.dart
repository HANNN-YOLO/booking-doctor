import 'package:cloud_firestore/cloud_firestore.dart';

// Model untuk menyimpan waktu yang tersedia
class AvailableTime {
  final String time;
  final bool isBooked;
  final DateTime date;

  AvailableTime({
    required this.time,
    this.isBooked = false,
    required this.date,
  });

  factory AvailableTime.fromMap(Map<String, dynamic> data) {
    return AvailableTime(
      time: data['time'] ?? '',
      isBooked: data['isBooked'] ?? false,
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'isBooked': isBooked,
      'date': Timestamp.fromDate(date),
    };
  }

  bool isAvailable() {
    return !isBooked && date.isAfter(DateTime.now());
  }

  String getDateTimeString() {
    return '${date.day}/${date.month}/${date.year} $time';
  }
}

// Model untuk menyimpan hari dan waktu yang tersedia
class AvailableDay {
  final String day;
  final List<AvailableTime> availableTimes;
  final DateTime weekStartDate; // Tanggal awal minggu

  AvailableDay({
    required this.day,
    required this.availableTimes,
    required this.weekStartDate, // Menambahkan parameter wajib untuk tanggal awal minggu
  });

  factory AvailableDay.fromMap(Map<String, dynamic> data) {
    return AvailableDay(
      day: data['day'] ?? '',
      availableTimes: (data['availableTimes'] as List<dynamic>?)
              ?.map((time) => AvailableTime.fromMap(time))
              .toList() ??
          [],
      weekStartDate: data['weekStartDate'] != null
          ? (data['weekStartDate'] as Timestamp).toDate()
          : DateTime.now(), // Default ke waktu sekarang jika tidak ada
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'availableTimes': availableTimes.map((time) => time.toMap()).toList(),
      'weekStartDate': Timestamp.fromDate(weekStartDate),
    };
  }

  // Method untuk mendapatkan jadwal yang tersedia untuk minggu tertentu
  List<AvailableTime> getAvailableTimesForWeek(DateTime weekOf) {
    return availableTimes.where((time) {
      final bool sameWeek = time.date.isAfter(weekOf) &&
          time.date.isBefore(weekOf.add(Duration(days: 7)));
      return sameWeek && time.isAvailable();
    }).toList();
  }
}

class Doctor {
  String kunci;
  final int id_doctor;
  final String name;
  final String specialty;
  final int experience;
  final String hospital;
  final String education;
  final List<AvailableDay> availableDays;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updateAt;

  Doctor({
    required this.kunci,
    required this.id_doctor,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.hospital,
    required this.education,
    required this.availableDays,
    required this.imageUrl,
    required this.createdAt,
    required this.updateAt,
  });

  factory Doctor.fromMap(Map<String, dynamic> data, String documentId) {
    return Doctor(
      kunci: documentId,
      id_doctor: data['id_doctor'] is int
          ? data['id_doctor']
          : int.tryParse(data['id_doctor'].toString()) ?? 0,
      name: data['name'] ?? '',
      specialty: data['specialty'] ?? '',
      experience: data['experience'] is int
          ? data['experience']
          : int.tryParse(data['experience'].toString()) ?? 0,
      hospital: data['hospital'] ?? '',
      education: data['education'] ?? '',
      availableDays: (data['availableDays'] as List<dynamic>?)
              ?.map((day) => AvailableDay.fromMap(day))
              .toList() ??
          [],
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updateAt: (data['updateAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kunci': kunci,
      'id_doctor': id_doctor,
      'name': name,
      'specialty': specialty,
      'experience': experience,
      'hospital': hospital,
      'education': education,
      'availableDays': availableDays.map((day) => day.toMap()).toList(),
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updateAt': updateAt
    };
  }
}
