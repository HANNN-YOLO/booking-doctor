import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';

class NotifikasiScreen extends StatelessWidget {
  static const String routeName = '/notifikasi';

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
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      // leading: CircleAvatar(
                      //   backgroundColor: Color(0xFF96D165),
                      //   child: Icon(
                      //     Icons.notifications_active,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      title: Text(
                        'Admin telah menyetujui untuk janji TemuDokter',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF96D165),
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
                            'pada ${booking.selectedDay} pukul ${booking.selectedTime}',
                            style: TextStyle(fontSize: 14),
                          ),
                          if (booking.approvedAt != null)
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
                        ],
                      ),
                      trailing: Icon(
                        Icons.check_circle,
                        color: Color(0xFF96D165),
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
