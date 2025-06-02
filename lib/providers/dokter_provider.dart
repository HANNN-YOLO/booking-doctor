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

  void create(
      // String kunci,
      String name,
      String specialty,
      String hospital,
      int experience,
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
      'specialty': specialty,
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

  DokterProvider(BuildContext context) {
    read(context);
  }
}
