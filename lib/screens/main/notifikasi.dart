import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import 'package:intl/intl.dart';

class NotifikasiScreen extends StatelessWidget {
  static const String routeName = '/notifikasi';

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

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          'Notifikasi',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          return StreamBuilder<List<Booking>>(
            stream: bookingProvider.getUserNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final notifications = snapshot.data;
              if (notifications == null || notifications.isEmpty) {
                return Center(child: Text('Belum ada notifikasi'));
              }

              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final booking = notifications[index];
                  final isApproved = booking.status == 'approved';

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(
                        isApproved
                            ? 'Admin telah menyetujui untuk janji TemuDokter'
                            : 'Admin telah menolak janji TemuDokter',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isApproved ? Color(0xFF96D165) : Colors.red,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'Dengan dr. ${booking.doctorName} (Spesialis ${booking.specialty})',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'pada ${_formatDate(booking.selectedDate)}, ${booking.selectedTime}',
                            style: TextStyle(fontSize: 14),
                          ),
                          if (isApproved && booking.approvedAt != null)
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'Disetujui pada: ${_formatDateTime(booking.approvedAt!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          if (!isApproved)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (booking.rejectedAt != null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Ditolak pada: ${_formatDateTime(booking.rejectedAt!)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                if (booking.rejectionReason != null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Alasan: ${booking.rejectionReason}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                      trailing: Icon(
                        isApproved ? Icons.check_circle : Icons.cancel,
                        color: isApproved ? Color(0xFF96D165) : Colors.red,
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
}
