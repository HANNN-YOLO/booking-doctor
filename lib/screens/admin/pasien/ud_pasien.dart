import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UdPasien extends StatelessWidget {
  static const arah = 'updatedelete_pasien';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "List Pasien",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
