import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateDokter extends StatelessWidget {
  static const arah = 'create_dokter';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Tambah DOkter",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
