import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Dokter")),
      body: ListView(
        children: [
          ChatBubble(text: "Halo Dokter!", isSender: true),
          ChatBubble(text: "Halo, ada yang bisa saya bantu?", isSender: false),
        ],
      ),
    );
  }
}