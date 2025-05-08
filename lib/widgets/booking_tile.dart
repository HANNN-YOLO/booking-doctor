import 'package:flutter/material.dart';

class BookingTile extends StatelessWidget {
  final String doctorName;
  final String date;

  BookingTile({required this.doctorName, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(doctorName),
      subtitle: Text(date),
    );
  }
}
