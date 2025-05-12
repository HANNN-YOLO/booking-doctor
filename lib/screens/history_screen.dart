import 'package:flutter/material.dart';
import '../widgets/booking_tile.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Konsultasi")),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Column(
            children: [
              BookingTile(
                doctorName: "Dr. Contoh $index",
                date: "10 Mei 2025",
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
