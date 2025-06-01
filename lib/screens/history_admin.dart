import 'package:flutter/material.dart';

class HistoryAdmin extends StatelessWidget {
  static const arah = 'history_admin';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          'List History',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
