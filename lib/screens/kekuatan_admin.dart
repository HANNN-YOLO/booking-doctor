import 'package:flutter/material.dart';

class kekuatan_admin extends StatelessWidget {
  static const arah = 'kekuatan_admin';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Kekuatan Admin",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
