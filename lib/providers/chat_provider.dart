import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final List<String> _messages = [
    'Halo Dokter!',
    'Halo, ada yang bisa saya bantu?',
    'Saya ingin konsultasi tentang demam anak saya.',
    'Baik, sejak kapan demamnya?',
  ];

  List<String> get messages => _messages;

  void sendMessage(String message) {
    _messages.add(message);
    notifyListeners();
  }
}
