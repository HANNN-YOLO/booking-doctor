import 'package:flutter/material.dart';

class UdDokter extends StatelessWidget {
  static const arah = 'updatedelete_dokter';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "List Dokter",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
