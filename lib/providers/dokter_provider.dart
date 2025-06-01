import 'package:booking_doctor/models/doctor.dart';
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

  void create(
      // String kunci,
      String name,
      String specialty,
      String hospital,
      String experience,
      String education,
      // String availableDay,
      // String availableTime,
      String imageurl,
      BuildContext context) async {
    final id_otomatis = DateTime.now().microsecondsSinceEpoch;
    final terisi = DateTime.now();

    final dokumentasi = _collection.doc();
    final kunci = dokumentasi.id;

    final Doctor = {
      'kunci': kunci,
      'id': id_otomatis,
      'name': name,
      'hospital': hospital,
      'experience': experience,
      'education': education,
      // 'availableDay': availableDay,
      // 'availableTime': availableTime,
      'imageUrl': imageurl,
      'createdAt': Timestamp.fromDate(terisi),
      'updateAt': Timestamp.fromDate(terisi),
    };

    if (Doctor.isNotEmpty) {
      await dokumentasi.set(Doctor);
      pemberitahuan(context, "Sudah di Tambahkan");
    } else {
      pemberitahuan(context, "Gagal di tambahkan");
    }
    notifyListeners();
    Navigator.of(context).pop();
  }

  void delete(BuildContext context, String kunci) async {
    final snapshot = await _collection.doc(kunci).get();

    final data = {};
    if (data.isEmpty) {
      pemberitahuan(context, "Berhasil di Hapus");
    } else {
      pemberitahuan(context, "Gagal di Hapus");
    }
    notifyListeners();
  }

  void read(BuildContext context) async {
    final tembakan =
        await FirebaseFirestore.instance.collection('doctor').get();

    if (tembakan.docs.isNotEmpty) {
      _dumydata.clear();
      for (var doc in tembakan.docs) {
        final dat = doc.data();
        _dumydata.add(Doctor.fromMap(dat, doc.id));
      }
      pemberitahuan(context, "Berhasil terambil");
    } else {
      pemberitahuan(context, "Gagal terambil");
    }
    notifyListeners();
  }

  void pemberitahuan(BuildContext context, String keluhkesah) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(keluhkesah),
      duration: Duration(seconds: 2),
    ));
  }

  DokterProvider(BuildContext context) {
    read(context);
  }
}
