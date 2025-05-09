import 'package:booking_doctor/screens/booking_screen.dart';
import 'package:booking_doctor/screens/chat_screen.dart';
import 'package:booking_doctor/screens/search_screen.dart';
import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatelessWidget {
  static const routing = 'detail';
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("Kembali"),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SearchScreen.routing);
                  },
                ),
                ElevatedButton(
                  child: Text("Buat Janji"),
                  onPressed: () {
                    pesan_booking_screeen(context);
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ChatScreen.routing);
                    },
                    child: Text("Keluh Kesah"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
