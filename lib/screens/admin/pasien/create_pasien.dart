import 'package:flutter/material.dart';

class CreatePasien extends StatelessWidget {
  static const arah = 'create_pasien';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Tammbah Pasien",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
