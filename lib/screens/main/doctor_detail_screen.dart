import 'package:booking_doctor/providers/dokter_provider.dart';
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

  Widget _buildScheduleRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: TextStyle(fontSize: 16)),
          Text(time, style: TextStyle(fontSize: 16)),
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
                          backgroundImage: AssetImage(
                              'assets/doctor_placeholder.png'), // Ganti dengan foto dokter jika ada
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
                      "Jam Kerja",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800]),
                    ),
                    SizedBox(height: 10),
                    _buildScheduleRow("Senin", "13.30"),
                    _buildScheduleRow("Rabu", "13.30"),
                    _buildScheduleRow("Jumat", "13.30"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF96D165),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text("Buat Janji",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                onPressed: () {
                  BookingScreen().pesan_booking_screen(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
