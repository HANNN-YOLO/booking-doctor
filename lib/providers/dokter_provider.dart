import 'package:booking_doctor/models/doctor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DokterProvider with ChangeNotifier {
  List<Doctor> _dumydata = [];
  List<Doctor> get dumydata {
    return [..._dumydata];
  }

  int get semuanya => _dumydata.length;

  Doctor data(String kunci) => _dumydata.firstWhere((e) => e.kunci == kunci);

  final _collection = FirebaseFirestore.instance.collection('doctor');

  String? _pilihan_Dokter;
  String get pilihanSpesialis => _pilihan_Dokter ?? 'Semua';

  // Menyimpan state untuk jadwal yang dipilih
  String? _selectedDay;
  String? _selectedTime;

  // Getter untuk jadwal yang dipilih
  String? get selectedDay => _selectedDay;
  String? get selectedTime => _selectedTime;

  // Fungsi untuk memilih hari
  void selectDay(String day) {
    _selectedDay = day;
    _selectedTime = null; // Reset waktu yang dipilih ketika hari baru dipilih
    notifyListeners();
  }

  // Fungsi untuk memilih waktu
  void selectTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  // Fungsi untuk mendapatkan waktu yang tersedia berdasarkan hari yang dipilih
  List<AvailableTime> getAvailableTimesForDay(String doctorId, String day) {
    final doctor = _dumydata.firstWhere((doc) => doc.kunci == doctorId);
    final selectedDaySchedule = doctor.availableDays.firstWhere(
      (availableDay) => availableDay.day == day,
      orElse: () => AvailableDay(
        day: day,
        availableTimes: [],
        weekStartDate:
            DateTime.now(), // Default ke waktu sekarang jika tidak ditemukan
      ),
    );
    return selectedDaySchedule.availableTimes;
  }

  void create(
      // String kunci,
      String name,
      String specialty,
      String hospital,
      int experience,
      String education,
      List<AvailableDay> availableDays,
      String imageurl,
      BuildContext context) async {
    final id_otomatis = DateTime.now().microsecondsSinceEpoch;
    final terisi = DateTime.now();

    final dokumentasi = _collection.doc();
    final kunci = dokumentasi.id;

    final Doctor = {
      'kunci': kunci,
      'id_doctor': id_otomatis,
      'name': name,
      'specialty': specialty,
      'hospital': hospital,
      'experience': experience,
      'education': education,
      'availableDays': availableDays.map((day) => day.toMap()).toList(),
      'imageUrl': imageurl,
      'createdAt': Timestamp.fromDate(terisi),
      'updateAt': Timestamp.fromDate(terisi),
    };

    if (Doctor.isNotEmpty) {
      await dokumentasi.set(Doctor);
      await read(context);
      pemberitahuan(context, "Sudah di Tambahkan");
    } else {
      pemberitahuan(context, "Gagal di tambahkan");
    }
    notifyListeners();
    Navigator.of(context).pop();
  }

  Future<void> read(BuildContext context) async {
    final tembakan =
        await FirebaseFirestore.instance.collection('doctor').get();

    if (tembakan.docs.isNotEmpty) {
      _dumydata.clear();
      for (var doc in tembakan.docs) {
        final dat = doc.data();
        _dumydata.add(Doctor.fromMap(dat, doc.id));
      }
      // pemberitahuan(context, "Berhasil terambil");
    } else {
      pemberitahuan(context, "Gagal terambil");
    }
    notifyListeners();
  }

  void delete(BuildContext context, String kunci) async {
    await _collection.doc(kunci).delete();
    await read(context);
    pemberitahuan(context, "Berhasil di hapus");
    notifyListeners();
  }

  void update(
      BuildContext context,
      String kunci,
      String name,
      String specialty,
      int experience,
      String hospital,
      String education,
      String imageurl) async {
    final terisi = DateTime.now();

    await _collection.doc(kunci).update({
      'name': name,
      'specialty': specialty,
      'experience': experience,
      'hospital': hospital,
      'education': education,
      'imageUrl': imageurl,
      'updateAt': Timestamp.fromDate(terisi),
    });
    await read(context);
    pemberitahuan(context, "Berhasil di Edit");
    Navigator.of(context).pop();
    notifyListeners();
  }

  void pemberitahuan(BuildContext context, String keluhkesah) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(keluhkesah),
      duration: Duration(seconds: 2),
    ));
  }

  void read_spesialis(String spesialis, BuildContext context) async {
    try {
      if (_pilihan_Dokter == spesialis) {
        // Jika spesialis yang sama diklik, reset ke semua dokter
        _pilihan_Dokter = null;
        final tembakan = await _collection.get();
        _dumydata = tembakan.docs
            .map((doc) => Doctor.fromMap(doc.data(), doc.id))
            .toList();
        pemberitahuan(context, "Menampilkan semua dokter");
      } else {
        // Pilih spesialis baru
        final tembakan =
            await _collection.where('specialty', isEqualTo: spesialis).get();
        _dumydata = tembakan.docs
            .map((doc) => Doctor.fromMap(doc.data(), doc.id))
            .toList();
        _pilihan_Dokter = spesialis;

        if (tembakan.docs.isNotEmpty) {
          pemberitahuan(context, "Menampilkan dokter spesialis $spesialis");
        } else {
          pemberitahuan(context, "Tidak ada dokter spesialis $spesialis");
        }
      }
    } catch (e) {
      pemberitahuan(context, "Terjadi kesalahan saat memuat data");
    }
    notifyListeners();
  }

  // Fungsi untuk mengupdate jadwal dokter
  Future<void> updateSchedule(
    String doctorId,
    List<AvailableDay> newSchedule,
    BuildContext context,
  ) async {
    try {
      await _collection.doc(doctorId).update({
        'availableDays': newSchedule.map((day) => day.toMap()).toList(),
        'updateAt': Timestamp.fromDate(DateTime.now()),
      });
      await read(context);
      pemberitahuan(context, "Jadwal berhasil diperbarui");
    } catch (e) {
      pemberitahuan(context, "Gagal memperbarui jadwal: ${e.toString()}");
    }
  }

  // Fungsi untuk menandai waktu sudah dibooking
  Future<void> markTimeAsBooked(
    String doctorId,
    String day,
    String time,
    BuildContext context,
  ) async {
    try {
      final doctor = _dumydata.firstWhere((doc) => doc.kunci == doctorId);
      final updatedSchedule = doctor.availableDays.map((availableDay) {
        if (availableDay.day == day) {
          final updatedTimes = availableDay.availableTimes.map((availableTime) {
            if (availableTime.time == time) {
              return AvailableTime(
                time: time,
                isBooked: true,
                date: availableTime.date, // Pertahankan tanggal yang sudah ada
              );
            }
            return availableTime;
          }).toList();
          return AvailableDay(
            day: day,
            availableTimes: updatedTimes,
            weekStartDate: availableDay
                .weekStartDate, // Pertahankan weekStartDate yang sudah ada
          );
        }
        return availableDay;
      }).toList();

      await updateSchedule(doctorId, updatedSchedule, context);
    } catch (e) {
      pemberitahuan(
          context, "Gagal menandai waktu sebagai dibooking: ${e.toString()}");
    }
  }

  DokterProvider(BuildContext context) {
    read(context);
  }
}
