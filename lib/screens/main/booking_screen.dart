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
  void pesan_booking_screen(BuildContext context) {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    final data = ModalRoute.of(context)?.settings.arguments as String;
    final doctor = Provider.of<DokterProvider>(context, listen: false)
        .dumydata
        .firstWhere((dat) => dat.kunci == data);

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
                  'Pilih Tanggal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: provider.dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    hintText: "Pilih Tanggal",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => provider.selectDate(context, doctor),
                ),
                SizedBox(height: 16),
                if (provider.selectedDay != null) ...[
                  Text(
                    'Pilih Waktu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: provider
                        .getAvailableTimesForDay(doctor)
                        .map(
                          (time) => ChoiceChip(
                            label: Text(time),
                            selected: provider.selectedTime == time,
                            onSelected: (selected) {
                              if (selected) {
                                provider.selectedTime = time;
                                provider.timeController.text = time;
                                provider.notifyListeners();
                              }
                            },
                          ),
                        )
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
}
