import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id_chat;
  final String id_doctor;
  final String sender; // 'user' atau 'doctor'
  final String message;
  final DateTime timestamp;

  Chat({
    required this.id_chat,
    required this.id_doctor,
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  /// Membuat ChatMessage dari data Firestore
  factory Chat.fromMap(Map<String, dynamic> data, String documentId) {
    final timestampData = data['timestamp'];

    return Chat(
      id_chat: documentId,
      id_doctor: data['doctorId'] ?? '',
      sender: data['sender'] ?? 'user',
      message: data['message'] ?? '',
      timestamp: timestampData is Timestamp
          ? timestampData.toDate()
          : DateTime.now(), // fallback jika null
    );
  }

  /// Mengubah ChatMessage menjadi Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'doctorId': id_doctor,
      'sender': sender,
      'message': message,
      'timestamp':
          Timestamp.fromDate(timestamp), // convert DateTime ke Firestore
    };
  }
}
