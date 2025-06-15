import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat.dart'; // Import Chat model
import '../../models/doctor.dart'; // Import Doctor model
import '../../providers/chat_provider.dart';
// import '../../providers/dokter_provider.dart'; // No longer needed

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final doctor = ModalRoute.of(context)?.settings.arguments
        as Doctor; // Retrieve Doctor object
    final chatProvider = Provider.of<ChatProvider>(context);

    // Set current doctor context in ChatProvider
    Future.microtask(() {
      Provider.of<ChatProvider>(context, listen: false)
          .setCurrentDoctor(doctor.kunci, doctor.specialty);
    });

    final messages = chatProvider.messages; // This will be of type List<Chat>

    return Scaffold(
      backgroundColor: Color(0xFFF0F2F5), // Slightly off-white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/',
            );
          },
        ),
        title: Row(
          children: [
            SizedBox(width: 8),
            Text("dr. ${doctor.name}",
                style: TextStyle(color: Colors.black)), // Use doctor.name
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
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        // Use addUserMessage, doctorId is now handled by ChatProvider
                        chatProvider.addUserMessage(text);
                        _controller.clear();
                      }
                    },
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
