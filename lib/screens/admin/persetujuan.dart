import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import 'package:intl/intl.dart';

class Persetujuan extends StatelessWidget {
  static const arah = 'persetujuan';

  String _formatDate(DateTime date) {
    // Konversi nama hari ke Indonesia
    final Map<String, String> dayNames = {
      'Monday': 'Senin',
      'Tuesday': 'Selasa',
      'Wednesday': 'Rabu',
      'Thursday': 'Kamis',
      'Friday': 'Jumat',
      'Saturday': 'Sabtu',
      'Sunday': 'Minggu',
    };

    // Format tanggal ke Bahasa Indonesia
    final Map<String, String> monthNames = {
      'January': 'Januari',
      'February': 'Februari',
      'March': 'Maret',
      'April': 'April',
      'May': 'Mei',
      'June': 'Juni',
      'July': 'Juli',
      'August': 'Agustus',
      'September': 'September',
      'October': 'Oktober',
      'November': 'November',
      'December': 'Desember',
    };

    String dayName = dayNames[DateFormat('EEEE').format(date)] ?? '';
    String monthName = monthNames[DateFormat('MMMM').format(date)] ?? '';

    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "List Persetujuan",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          return StreamBuilder<List<Booking>>(
            stream: bookingProvider.getPendingBookings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final bookings = snapshot.data;
              if (bookings == null || bookings.isEmpty) {
                return Center(
                    child: Text('Tidak ada booking yang menunggu persetujuan'));
              }

              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ID Pasien: ${booking.patientId}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'ID Dokter: ${booking.doctorId}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Menunggu',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Jadwal: ${_formatDate(booking.bookingDate)}, ${booking.time}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _showRejectDialog(
                                    context, booking.id, bookingProvider),
                                child: Text(
                                  'Tolak',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await bookingProvider.approveBooking(
                                        booking.id, context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Booking berhasil disetujui'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF96D165),
                                ),
                                child: Text(
                                  'Setujui',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showRejectDialog(
      BuildContext context, String bookingId, BookingProvider bookingProvider) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alasan Penolakan'),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            hintText: 'Masukkan alasan penolakan',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Harap masukkan alasan penolakan'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              try {
                await bookingProvider.rejectBooking(
                  bookingId,
                  reasonController.text,
                  context,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking berhasil ditolak'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Tolak Booking',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
