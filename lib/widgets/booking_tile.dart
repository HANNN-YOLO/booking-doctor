import 'package:flutter/material.dart';

class BookingTile extends StatelessWidget {
  final String doctorName;
  final String date;

  BookingTile({required this.doctorName, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.calendar_today),
      title: Text(doctorName),
      subtitle: Text(date),
    );
  }
}
