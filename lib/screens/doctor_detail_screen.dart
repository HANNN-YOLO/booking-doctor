import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Dokter")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text("Dr. Contoh"),
            subtitle: Text("Spesialis Umum"),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Jadwal: Senin - Jumat, 08:00 - 16:00"),
          ),
          Center(
            child: ElevatedButton(
              child: Text("Buat Janji"),
              onPressed: () {
                Navigator.pushNamed(context, '/booking');
              },
            ),
          ),
        ],
      ),
    );
  }
}
