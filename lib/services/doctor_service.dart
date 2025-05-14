import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';

class DoctorService {
  final CollectionReference _doctorRef =
      FirebaseFirestore.instance.collection('doctors');

  Future<List<Doctor>> getDoctors() async {
    final snapshot = await _doctorRef.get();
    return snapshot.docs
        .map((doc) => Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addDoctor(Doctor doctor) async {
    await _doctorRef.add(doctor.toMap());
  }
}

