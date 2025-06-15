import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/chat.dart'; // Import Chat model
import '../../models/doctor.dart'; // Import Doctor model
import '../../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  Doctor? _doctor; // To store the doctor details

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final doctor = ModalRoute.of(context)?.settings.arguments as Doctor?;
      final user = FirebaseAuth.instance.currentUser;
      final String patientId = user?.uid ?? '';

      if (doctor != null && patientId.isNotEmpty) {
        setState(() {
          _doctor =
              doctor; // Store doctor for use in build method for AppBar title
        });
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        // setCurrentDoctor will handle clearing previous messages and starting the new listener
        chatProvider.setCurrentDoctor(
            doctor.kunci, doctor.specialty, patientId);
      } else {
        // Handle case where doctor is null, perhaps pop or show an error
        print(
            "Error: Doctor details or patientId not found in ChatScreen initState.");
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    // Dispose listener when the screen is disposed
    Provider.of<ChatProvider>(context, listen: false).disposeListener();
    _controller.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.sendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access ChatProvider here for messages, will rebuild when messages change
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.chats;

    // Display a loading indicator or placeholder if _doctor is null
    if (_doctor == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading Chat...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF0F2F5), // Slightly off-white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Before navigating away, ensure the listener for this chat is disposed.
            // This is handled by the general dispose() method, but if navigating
            // to a state where ChatProvider might be immediately reused for a *different*
            // doctor without this ChatScreen being fully disposed, explicit cleanup here might be needed.
            // However, standard navigation should trigger dispose().
            Navigator.pushNamed(
              context,
              '/', // Assuming '/' is your main/home route
            );
          },
        ),
        title: Row(
          children: [
            SizedBox(width: 8),
            Text("dr. ${_doctor!.name}", // Use _doctor here
                style: TextStyle(color: Colors.black)),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final chatMessage = messages[index];
                final bool isUserMessage = chatMessage.sender == 'user';
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? Color(0xFF96D165)
                          : Colors.grey[300], // User: Green, Bot: Grey
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      chatMessage.message,
                      style: TextStyle(
                        fontSize: 16,
                        color: isUserMessage
                            ? Colors.white
                            : Colors.black87, // Text color based on sender
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 12, vertical: 8), // Consistent padding
            color: Colors.white, // White background for input area
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Ketik pesan...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(), // Send on submit
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage, // Use the extracted method
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
