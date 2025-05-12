import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Booking Janji")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null && provider.selectDateTime != null) {
                  final combined = DateTime(
                    provider.selectDateTime!.year,
                    provider.selectDateTime!.month,
                    provider.selectDateTime!.day,
                    time.hour,
                    time.minute,
                  );
                  provider.setDateTime(combined);
                }
              },
              child: Text("Pilih Jam"),
            ),
            SizedBox(height: 16),
            if (provider.selectDateTime != null)
              Text(
                "Booking: ${provider.selectDateTime}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Booking dikonfirmasi")),
                );
              },
              child: Text("Konfirmasi Booking"),
            ),
          ],
        ),
      ),
    );
  }
}
