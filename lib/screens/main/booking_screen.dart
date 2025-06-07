import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/booking_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/dokter_provider.dart';
import '../../models/doctor.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../providers/booking_provider.dart';

class BookingScreen {
  final String doctorKey;

  BookingScreen({required this.doctorKey});

  // Konversi nama hari ke Bahasa Indonesia
  String _getDayName(String englishDay) {
    final Map<String, String> dayNames = {
      'Monday': 'Senin',
      'Tuesday': 'Selasa',
      'Wednesday': 'Rabu',
      'Thursday': 'Kamis',
      'Friday': 'Jumat',
      'Saturday': 'Sabtu',
      'Sunday': 'Minggu',
    };
    return dayNames[englishDay] ?? englishDay;
  }

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
          builder: (context, provider, child) {
            // Cek apakah tanggal memiliki jadwal tersedia
            bool hasAvailableSlots(DateTime date) {
              final dayName = _getDayName(DateFormat('EEEE').format(date));
              final availableDay = doctor.availableDays.firstWhere(
                (day) => day.day == dayName,
                orElse: () => AvailableDay(
                  day: '',
                  availableTimes: [],
                  weekStartDate: DateTime.now(),
                ),
              );
              return availableDay.availableTimes.any((time) => !time.isBooked);
            }

            // Mendapatkan slot waktu yang tersedia untuk tanggal tertentu
            List<AvailableTime> getAvailableTimesForDate(DateTime date) {
              final dayName = _getDayName(DateFormat('EEEE').format(date));
              final availableDay = doctor.availableDays.firstWhere(
                (day) => day.day == dayName,
                orElse: () => AvailableDay(
                  day: '',
                  availableTimes: [],
                  weekStartDate: DateTime.now(),
                ),
              );
              return availableDay.availableTimes
                  .where((time) => !time.isBooked)
                  .toList();
            }

            return Container(
              height: 550,
              width: 450,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar
                  Card(
                    margin: EdgeInsets.all(8.0),
                    elevation: 5,
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(Duration(days: 30)),
                      focusedDay: provider.selectedDate ?? DateTime.now(),
                      selectedDayPredicate: (day) =>
                          isSameDay(provider.selectedDate, day),
                      calendarFormat: CalendarFormat.month,
                      availableGestures: AvailableGestures.all,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        weekendTextStyle:
                            TextStyle().copyWith(color: Colors.red),
                        holidayTextStyle:
                            TextStyle().copyWith(color: Colors.red),
                      ),
                      enabledDayPredicate: (day) {
                        return hasAvailableSlots(day) &&
                            day.isAfter(
                                DateTime.now().subtract(Duration(days: 1)));
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        provider.selectedDate = selectedDay;
                        provider.selectedDay =
                            _getDayName(DateFormat('EEEE').format(selectedDay));
                        provider.selectedTime = null;
                        provider.notifyListeners();
                      },
                    ),
                  ),

                  // Available Time Slots
                  if (provider.selectedDate != null) ...[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Jadwal Tersedia - ${DateFormat('dd MMMM yyyy').format(provider.selectedDate!)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              getAvailableTimesForDate(provider.selectedDate!)
                                  .map((time) => ChoiceChip(
                                        label: Text(time.time),
                                        selected:
                                            provider.selectedTime == time.time,
                                        onSelected: (selected) {
                                          if (selected) {
                                            provider.selectedTime = time.time;
                                            provider.timeController.text =
                                                time.time;
                                            provider.notifyListeners();
                                          }
                                        },
                                      ))
                                  .toList(),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Center(
                        child: Text(
                          'Pilih tanggal untuk melihat jadwal tersedia',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Action Buttons
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
                                final success = await provider.createBooking(
                                    doctor, context);
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
            );
          },
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
