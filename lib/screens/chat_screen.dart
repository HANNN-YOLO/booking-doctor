import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      appBar: AppBar(
        title: Text("Chat Dokter"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/detail');
              },
              icon: Icon(Icons.person))
        ],
      ),
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
