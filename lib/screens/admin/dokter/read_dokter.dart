import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReadDokter extends StatelessWidget {
  static const arah = 'read_dokter';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Detail Dokter",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
