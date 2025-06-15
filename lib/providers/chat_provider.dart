import 'package:flutter/material.dart';
import '../models/chat.dart'; // Import the Chat model
import '../services/chat_service.dart'; // Import ChatService

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService(); // Instantiate ChatService
  final List<Chat> _messages = []; // Initialize as empty List<Chat>

  String? _currentDoctorId;
  String? _currentDoctorSpecialty;

  List<Chat> get messages => _messages; // Return List<Chat>

  // Set the current doctor context for the chat
  void setCurrentDoctor(String doctorId, String specialty) {
    bool needsNotification = false;

    // If the active doctor is changing, clear messages from the previous chat.
    if (_currentDoctorId != null && _currentDoctorId != doctorId) {
      _messages.clear();
      needsNotification = true; // State change: messages list cleared
    }

    // Update the doctor ID if it has changed.
    if (_currentDoctorId != doctorId) {
      _currentDoctorId = doctorId;
      needsNotification = true; // State change: doctorId updated
    }

    // Update the doctor specialty if it has changed.
    if (_currentDoctorSpecialty != specialty) {
      _currentDoctorSpecialty = specialty;
      needsNotification = true; // State change: specialty updated
    }

    // If any state that UI might depend on has changed, notify listeners.
    if (needsNotification) {
      notifyListeners();
    }
  }

  // Add a new message from the user and get a bot response
  Future<void> addUserMessage(String messageText) async {
    if (_currentDoctorId == null || _currentDoctorSpecialty == null) {
      // Or handle this error more gracefully
      print("Error: Doctor context not set in ChatProvider.");
      return;
    }

    // 1. Add user's message
    final userMessage = Chat(
      id_chat: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
      id_doctor: _currentDoctorId!,
      sender: 'user',
      message: messageText,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    notifyListeners(); // Notify for user message first so it appears instantly

    // 2. Get bot's response
    final String botResponseText = await _chatService.getBotResponse(
        messageText, _currentDoctorSpecialty!);

    // 3. Add bot's message
    final botMessage = Chat(
      id_chat: (DateTime.now().millisecondsSinceEpoch + 1)
          .toString(), // Temporary ID, ensure uniqueness
      id_doctor: _currentDoctorId!,
      sender: 'doctor', // Or a constant for bot/doctor
      message: botResponseText,
      timestamp: DateTime.now(),
    );
    _messages.add(botMessage);
    notifyListeners(); // Notify after bot message is added
  }
}
