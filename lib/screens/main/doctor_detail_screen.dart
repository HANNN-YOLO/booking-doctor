import 'package:booking_doctor/providers/dokter_provider.dart';
import 'package:booking_doctor/providers/booking_provider.dart';
import 'package:booking_doctor/models/booking.dart';
import 'package:booking_doctor/models/doctor.dart';
import 'package:flutter/material.dart';
import './booking_screen.dart';
import 'package:provider/provider.dart';

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({super.key});

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.black87),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildScheduleItem(String time, bool isBooked, Function()? onTap) {
    return Container(
      margin: EdgeInsets.only(right: 8, bottom: 8),
      child: FilterChip(
        label: Text(time),
        selected: false,
        onSelected: isBooked ? null : (_) => onTap?.call(),
        backgroundColor: isBooked ? Colors.grey[300] : Color(0xFF96D165),
        labelStyle: TextStyle(
          color: isBooked ? Colors.grey[600] : Colors.white,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _showBookingDialog(
      BuildContext context, Doctor doctor, DateTime date, String time) {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${date.day}/${date.month}/${date.year}'),
            Text('Waktu: $time'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF96D165),
            ),
            onPressed: () async {
              try {
                // Check availability first
                bool isAvailable = await bookingProvider.checkAvailability(
                  doctor.kunci,
                  date,
                  time,
                );

                if (!isAvailable) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Maaf, jadwal ini sudah dibooking'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.pop(context);
                  return;
                }

                // Create booking
                await bookingProvider.createBooking(
                  doctor,
                  date,
                  time = time,
                  context,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking berhasil dibuat!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Terjadi kesalahan: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as String;
    final mydata = Provider.of<DokterProvider>(context)
        .dumydata
        .firstWhere((dat) => dat.kunci == data);
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165), // Hijau terang
        title: const Text(
          "TemuDok",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage("${mydata.imageUrl}"),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Dr. ${mydata.name}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("Spesialis ${mydata.specialty}",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600])),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text("20 Juni 2025",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text("13.30 - 16.30",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.7,
                      backgroundColor: Colors.grey[300],
                      color: Color(0xFF96D165),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(Icons.people, "7,500+", "Pasien"),
                _buildStatItem(Icons.work, "7+", "Pengalaman"),
                _buildStatItem(Icons.star, "4.5+", "Rating"),
                _buildStatItem(Icons.chat, "4,567+", "Review"),
              ],
            ),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tentang",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Dr. ${mydata.name} adalah spesialis ${mydata.specialty}  yang berpraktik di ${mydata.hospital} . "
                      "Beliau memiliki pengalaman lebih dari ${mydata.experience} tahun dan merupakan lulusan dari ${mydata.education} . "
                      "Dr. ${mydata.name} dikenal karena dedikasinya dalam memberikan layanan kesehatan yang profesional dan empatik. Ia telah menangani ribuan pasien dengan berbagai kasus medis.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jadwal Praktik",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    ...mydata.availableDays.map((day) {
                      // Get the specific date for this day
                      final date = day.weekStartDate;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              child: Text(
                                day.day,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: StreamBuilder<List<Booking>>(
                                stream: bookingProvider
                                    .getBookingsByDoctor(mydata.kunci),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  final bookings = snapshot.data ?? [];

                                  return Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: day.availableTimes.map((time) {
                                      // Check if this time slot is booked
                                      final isBooked = bookings.any((booking) =>
                                          booking.bookingDate.year ==
                                              date.year &&
                                          booking.bookingDate.month ==
                                              date.month &&
                                          booking.bookingDate.day == date.day &&
                                          booking.time == time.time &&
                                          ['pending', 'confirmed']
                                              .contains(booking.status));

                                      return _buildScheduleItem(
                                        time.time,
                                        isBooked,
                                        () => _showBookingDialog(
                                          context,
                                          mydata,
                                          time.date,
                                          time.time,
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF96D165),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text("Buat Janji",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: () {
                      if (mydata.availableDays.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Maaf, tidak ada jadwal yang tersedia"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      BookingScreen(doctorKey: mydata.kunci)
                          .tampilkanDialog(context);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF96D165),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/chat', arguments: mydata);
                    },
                    child: Text("Chat Dokter",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
