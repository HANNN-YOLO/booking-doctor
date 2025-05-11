import 'package:flutter/material.dart';
import '../widgets/booking_tile.dart';
import '/screens/search_screen.dart';

class HistoryScreen extends StatelessWidget {
  static const routing = 'history';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Konsultasi")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 700,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return BookingTile(
                    doctorName: "Dr. Contoh $index",
                    date: "10 Mei 2025",
                  );
                },
              ),
            ),
            Container(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SearchScreen.routing);
                  },
                  child: Text(
                    "Kembali",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
