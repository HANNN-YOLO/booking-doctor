import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/booking_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/dokter_provider.dart';
import '../../models/doctor.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../providers/booking_provider.dart';

class BookingScreen {
  final String doctorKey;

  BookingScreen({required this.doctorKey});

  void tampilkanDialog(BuildContext context) {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    final doctor = Provider.of<DokterProvider>(context, listen: false)
        .dumydata
        .firstWhere((dat) => dat.kunci == doctorKey);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buat Janji dengan Dr. ${doctor.name}'),
        content: Consumer<BookingProvider>(
          builder: (context, provider, child) => Container(
            height: 400,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Hari Praktik',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ...doctor.availableDays
                    .map(
                      (day) => CheckboxListTile(
                        title: Text(day.day),
                        value: provider.selectedDay == day.day,
                        onChanged: (bool? value) {
                          if (value == true) {
                            provider.selectedDay = day.day;
                            provider.dateController.text = day.day;
                            provider.notifyListeners();
                          }
                        },
                      ),
                    )
                    .toList(),
                if (provider.selectedDay != null) ...[
                  SizedBox(height: 16),
                  Text(
                    'Pilih Waktu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: doctor.availableDays
                        .firstWhere((d) => d.day == provider.selectedDay)
                        .availableTimes
                        .where((time) => !time.isBooked)
                        .map((time) => ChoiceChip(
                              label: Text(time.time),
                              selected: provider.selectedTime == time.time,
                              onSelected: (selected) {
                                if (selected) {
                                  provider.selectedTime = time.time;
                                  provider.timeController.text = time.time;
                                  provider.notifyListeners();
                                }
                              },
                            ))
                        .toList(),
                  ),
                ],
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        provider.resetForm();
                        Navigator.pop(context);
                      },
                      child: Text('Batal'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: provider.selectedDay != null &&
                              provider.selectedTime != null
                          ? () async {
                              final success =
                                  await provider.createBooking(doctor, context);
                              if (success) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Booking berhasil dibuat! Silakan tunggu konfirmasi.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Text('Konfirmasi Booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF96D165),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is now empty as the dialog is handled by the tampilkanDialog method
    return Container();
  }
}
