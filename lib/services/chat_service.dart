import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/chat.dart'; // Ensure this path is correct

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'chats';

  String getConversationId(String doctorId, String patientId) {
    return '${doctorId}_$patientId';
  }

  // Mengirim pesan baru ke subcollection messages
  Future<void> sendMessage({
    required String doctorId,
    required String patientId,
    required String message,
    required String sender,
  }) async {
    try {
      final conversationId = getConversationId(doctorId, patientId);
      final chatDoc = _firestore.collection(_collection).doc(conversationId);
      // Cek apakah dokumen percakapan sudah ada
      final docSnapshot = await chatDoc.get();
      if (!docSnapshot.exists) {
        // Ambil data dokter dari Firestore
        final doctorSnap =
            await _firestore.collection('doctor').doc(doctorId).get();
        final doctorData = doctorSnap.data() ?? {};
        final doctorName = doctorData['name'] ?? '';
        final doctorSpecialty = doctorData['specialty'] ?? '';
        // Ambil data pasien dari Realtime Database (dengan path benar)
        final patientSnap = await FirebaseDatabase.instance
            .ref('pasien_profiles/$patientId')
            .get();
        final patientData = patientSnap.value as Map?;
        String patientName = '';
        int patientAge = 0;
        if (patientData != null) {
          patientName = patientData['nama'] ?? '';
          if (patientData['tgllahir'] != null) {
            final birthDate = DateTime.tryParse(patientData['tgllahir']);
            if (birthDate != null) {
              final now = DateTime.now();
              patientAge = now.year -
                  birthDate.year -
                  ((now.month < birthDate.month ||
                          (now.month == birthDate.month &&
                              now.day < birthDate.day))
                      ? 1
                      : 0);
            }
          }
        }
        // Buat dokumen percakapan dengan data lengkap
        await chatDoc.set({
          'doctorId': doctorId,
          'doctorName': doctorName,
          'doctorSpecialty': doctorSpecialty,
          'patientId': patientId,
          'patientName': patientName,
          'patientAge': patientAge,
        }, SetOptions(merge: true));
      }
      // Tambahkan pesan ke subcollection messages
      final chat = Chat(
        sender: sender,
        message: message,
        timestamp: DateTime.now(),
      );
      await chatDoc.collection('messages').add(chat.toMap());
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // Mendapatkan stream pesan untuk satu percakapan
  Stream<List<Chat>> getMessagesForConversation(
      String doctorId, String patientId) {
    final conversationId = getConversationId(doctorId, patientId);
    return _firestore
        .collection(_collection)
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Chat.fromMap(doc.data())).toList());
  }

  // Mendapatkan semua percakapan untuk dokter tertentu
  Stream<QuerySnapshot> getAllConversationsForDoctor(String doctorId) {
    return _firestore
        .collection(_collection)
        .where('doctorId', isEqualTo: doctorId)
        .snapshots();
  }

  // Fungsi respons bot (masih bisa digunakan)
  Future<String> getBotResponse(String userMessage, String specialty) async {
    await Future.delayed(Duration(milliseconds: 500 + userMessage.length * 10));
    String messageLowerCase = userMessage.toLowerCase();
    switch (specialty.toLowerCase()) {
      case 'umum':
        if (messageLowerCase.contains('halo') ||
            messageLowerCase.contains('selamat pagi')) {
          return 'Halo! Ada yang bisa saya bantu hari ini?';
        } else if (messageLowerCase.contains('demam') ||
            messageLowerCase.contains('pusing')) {
          return 'Tentu, bisa ceritakan lebih lanjut mengenai gejala demam atau pusing yang Anda rasakan? Sejak kapan ini terjadi?';
        } else if (messageLowerCase.contains('batuk') ||
            messageLowerCase.contains('pilek')) {
          return 'Untuk batuk dan pilek, apakah disertai dahak atau gejala lain seperti sakit tenggorokan?';
        } else {
          return 'Maaf, saya belum sepenuhnya mengerti. Bisa Anda jelaskan keluhan utama Anda?';
        }
      case 'anak':
        if (messageLowerCase.contains('halo')) {
          return 'Halo Bunda/Ayah! Ada yang bisa saya bantu terkait kesehatan si kecil?';
        } else if (messageLowerCase.contains('demam anak') ||
            messageLowerCase.contains('anak saya demam')) {
          return 'Baik, demam pada anak memang sering membuat khawatir. Berapa usia si kecil dan berapa suhu tubuhnya jika sudah diukur?';
        } else if (messageLowerCase.contains('vaksin') ||
            messageLowerCase.contains('imunisasi')) {
          return 'Terkait vaksinasi, jenis vaksin apa yang ingin Anda tanyakan atau apakah ada jadwal yang terlewat?';
        } else {
          return 'Saya di sini untuk membantu masalah kesehatan anak. Apa keluhan spesifik si kecil?';
        }
      case 'kandungan':
        if (messageLowerCase.contains('halo') ||
            messageLowerCase.contains('selamat pagi')) {
          return 'Halo! Ada yang bisa saya bantu terkait kesehatan kandungan atau kewanitaan?';
        } else if (messageLowerCase.contains('hamil') ||
            messageLowerCase.contains('kehamilan')) {
          return 'Tentu, selamat atas kehamilannya jika sedang hamil! Ada pertanyaan spesifik mengenai trimester saat ini atau keluhan tertentu?';
        } else if (messageLowerCase.contains('kontrasepsi') ||
            messageLowerCase.contains('kb')) {
          return 'Untuk konsultasi mengenai KB, jenis apa yang sedang Anda pertimbangkan atau gunakan?';
        } else {
          return 'Silakan sampaikan keluhan atau pertanyaan Anda seputar kesehatan kandungan dan kewanitaan.';
        }
      case 'gigi':
        if (messageLowerCase.contains('sakit gigi')) {
          return 'Sakit gigi bisa sangat mengganggu. Sebelah mana gigi yang sakit dan seperti apa rasa sakitnya?';
        } else {
          return 'Ada masalah dengan gigi atau gusi Anda? Silakan ceritakan.';
        }
      case 'jantung':
        if (messageLowerCase.contains('dada sakit') ||
            messageLowerCase.contains('jantung berdebar')) {
          return 'Keluhan di area jantung perlu perhatian. Bisa Anda deskripsikan lebih detail rasa sakitnya dan kapan biasanya muncul?';
        } else {
          return 'Saya adalah spesialis jantung. Apa yang bisa saya bantu?';
        }
      case 'kulit dan kelamin':
        if (messageLowerCase.contains('gatal') ||
            messageLowerCase.contains('ruam')) {
          return 'Baik, untuk keluhan kulit seperti gatal atau ruam, apakah ada perubahan warna atau tekstur kulit di area tertentu?';
        } else {
          return 'Layanan konsultasi spesialis kulit dan kelamin. Apa keluhan Anda?';
        }
      case 'tht':
        if (messageLowerCase.contains('telinga sakit') ||
            messageLowerCase.contains('hidung tersumbat') ||
            messageLowerCase.contains('tenggorokan sakit')) {
          return 'Keluhan THT seperti sakit telinga, hidung tersumbat, atau sakit tenggorokan bisa sangat beragam. Bisa ceritakan lebih detail?';
        } else {
          return 'Ini adalah layanan konsultasi THT. Apa yang bisa saya bantu?';
        }
      case 'mata':
        if (messageLowerCase.contains('mata merah') ||
            messageLowerCase.contains('penglihatan kabur')) {
          return 'Untuk masalah mata seperti mata merah atau penglihatan kabur, apakah terjadi pada satu atau kedua mata? Ada gejala lain?';
        } else {
          return 'Konsultasi dokter spesialis mata. Ada keluhan pada mata Anda?';
        }
      default:
        return 'Selamat datang di layanan konsultasi. Saya adalah dokter spesialis virtual di bidang ${specialty}. Apa yang bisa saya bantu?';
    }
  }
}
