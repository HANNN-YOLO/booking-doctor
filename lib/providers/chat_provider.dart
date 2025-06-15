import 'dart:async'; // Import for StreamSubscription

import 'package:flutter/material.dart';
import '../models/chat.dart'; // Import the Chat model
import '../services/chat_service.dart'; // Import ChatService
import 'package:flutter/foundation.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService(); // Instantiate ChatService
  List<Chat> _chats = [];
  bool _isLoading = false;

  String? _currentDoctorId;
  String? _currentDoctorSpecialty;
  String? _currentPatientId;

  StreamSubscription? _messagesSubscription; // To hold the stream subscription

  List<Chat> get chats => _chats;
  bool get isLoading => _isLoading;

  List<Chat> get messages => _chats; // Return List<Chat>

  // Set the current doctor and patient context for the chat
  void setCurrentDoctor(String doctorId, String specialty, String patientId) {
    if (_currentDoctorId != doctorId || _currentPatientId != patientId) {
      _chats.clear();
      _currentDoctorId = doctorId;
      _currentDoctorSpecialty = specialty;
      _currentPatientId = patientId;
      disposeListener();
      loadChats(doctorId, patientId);
      notifyListeners();
    } else if (_currentDoctorSpecialty != specialty) {
      _currentDoctorSpecialty = specialty;
      notifyListeners();
    }
  }

  // Mendapatkan chat untuk satu percakapan
  Future<void> loadChats(String doctorId, String patientId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _messagesSubscription?.cancel();
      _messagesSubscription = _chatService
          .getMessagesForConversation(doctorId, patientId)
          .listen((chats) {
        _chats = chats;
        notifyListeners();
      });
    } catch (e) {
      print('Error loading chats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mengirim pesan dan mendapatkan respons dari chatbot
  Future<void> sendMessage(String message) async {
    if (_currentDoctorId == null || _currentPatientId == null) {
      print('Error: No doctor or patient selected');
      return;
    }

    try {
      // Kirim pesan user
      await _chatService.sendMessage(
        doctorId: _currentDoctorId!,
        patientId: _currentPatientId!,
        message: message,
        sender: 'user',
      );

      // Simulasi respons chatbot
      String botResponse = _generateBotResponse(message);

      // Kirim respons chatbot
      await _chatService.sendMessage(
        doctorId: _currentDoctorId!,
        patientId: _currentPatientId!,
        message: botResponse,
        sender: 'doctor',
      );
    } catch (e) {
      print('Error in sendMessage: $e');
      rethrow;
    }
  }

  // Fungsi sederhana untuk mensimulasikan respons chatbot
  String _generateBotResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();

    if (userMessage.contains('halo') || userMessage.contains('hai')) {
      return 'Halo! Saya adalah asisten dokter. Apa yang bisa saya bantu?';
    } else if (userMessage.contains('sakit')) {
      return 'Mohon jelaskan lebih detail tentang keluhan Anda. Kapan mulai terasa sakitnya?';
    } else if (userMessage.contains('demam')) {
      return 'Berapa suhu tubuh Anda saat ini? Apakah ada gejala lain yang menyertai?';
    } else {
      return 'Mohon maaf, saya perlu informasi lebih detail untuk bisa membantu Anda dengan lebih baik.';
    }
  }

  // Dispose the listener when the provider is disposed
  void disposeListener() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
  }

  @override
  void dispose() {
    disposeListener(); // Clean up the listener
    super.dispose();
  }
}
