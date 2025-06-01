import 'package:booking_doctor/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DokterProvider with ChangeNotifier {
  List<Doctor> _dumydata = [];
  List<Doctor> get dummydata {
    return [..._dumydata];
  }

  int get semuanya => _dumydata.length;

  Doctor data(String kunci) => _dumydata.firstWhere((e) => e.kunci == kunci);

  final _collection = FirebaseFirestore.instance.collection('doctor');

  void create(
      String kunci,
      String name,
      String specialty,
      String hospital,
      String experience,
      String education,
      String availableDay,
      String availableTime,
      String imageurl,
      BuildContext context) async {
    final id_otomatis = DateTime.now().microsecondsSinceEpoch;
    final terisi = DateTime.now();

    final dokumentasi = _collection.doc();
    final kunci = dokumentasi.id;

    final data = {
      'id': id_otomatis,
      'hospital': hospital,
      'experience': experience,
      'education': education,
      'availableDay': availableDay,
      'availableTime': availableTime,
      'imageUrl': imageurl,
      'createdAt': Timestamp.fromDate(terisi),
      'updateAt': Timestamp.fromDate(terisi),
    };

    if (data.isNotEmpty) {
      await dokumentasi.set(data);
      pemberitahuan(context, "Sudah di Tambahkan");
    } else {
      pemberitahuan(context, "Gagal di tambahkan");
    }
    notifyListeners();
  }

  void pemberitahuan(BuildContext context, String keluhkesah) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(keluhkesah),
      duration: Duration(seconds: 2),
    ));
  }
}
