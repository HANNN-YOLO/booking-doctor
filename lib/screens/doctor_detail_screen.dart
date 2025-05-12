import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Dokter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            SizedBox(height: 12),
            Text("Dr. Contoh", style: TextStyle(fontSize: 20)),
            Text("Spesialis Umum"),
            SizedBox(height: 16),
            Text("Jadwal: Senin - Jumat, 08:00 - 16:00"),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/booking');
              },
              child: Text("Buat Janji"),
            ),
          ],
        ),
      ),
    );
  }
}
