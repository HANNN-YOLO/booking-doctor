import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReadPasien extends StatelessWidget {
  static const arah = 'read_pasien';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Detail Pasien",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
