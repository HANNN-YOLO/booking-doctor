import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  final List<String> messages = [
    'Halo Dokter!',
    'Halo, ada yang bisa saya bantu?',
    'Saya ingin konsultasi tentang demam anak saya.',
    'Baik, sejak kapan demamnya?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Dokter")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ChatBubble(
            text: messages[index],
            isSender: index % 2 == 0, // gantian antara pasien & dokter
          );
        },
      ),
    );
  }
}
