import 'package:flutter/material.dart';

class Persetujuan extends StatelessWidget {
  static const arah = 'persetujuan';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "List Persetujuan",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
