import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Booking Janji")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                provider.setDateTime(date);
              }
            },
            child: Text("Pilih Tanggal"),
          ),
          ElevatedButton(
            onPressed: () {
              // Konfirmasi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Booking dikonfirmasi")),
              );
            },
            child: Text("Konfirmasi Booking"),
          ),
        ],
      ),
    );
  }
}
