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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/create_dokter');
            },
            icon: Icon(Icons.add),
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
