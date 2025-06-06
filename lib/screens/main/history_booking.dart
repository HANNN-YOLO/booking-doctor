import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';

class HistoryBookingScreen extends StatelessWidget {
  static const String routeName = '/history-booking';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF96D165),
          title: Text(
            'Riwayat Booking',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Disetujui'),
              Tab(text: 'Ditolak'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingHistoryList(status: 'approved'),
            _BookingHistoryList(status: 'rejected'),
          ],
        ),
      ),
    );
  }
}

class _BookingHistoryList extends StatelessWidget {
  final String status;

  const _BookingHistoryList({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        return StreamBuilder<List<Booking>>(
          stream: bookingProvider.getUserBookings(status),
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
                child: Text(
                  status == 'approved'
                      ? 'Belum ada booking yang disetujui'
                      : 'Belum ada booking yang ditolak',
                ),
              );
            }

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF96D165),
                      child: Icon(
                        Icons.medical_services,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'dr. ${booking.doctorName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Spesialis ${booking.specialty}'),
                        Text('${booking.selectedDay}, ${booking.selectedTime}'),
                        if (status == 'approved' && booking.approvedAt != null)
                          Text(
                            'Disetujui pada: ${_formatDateTime(booking.approvedAt!)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        if (status == 'rejected' &&
                            booking.rejectionReason != null)
                          Text(
                            'Alasan: ${booking.rejectionReason}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: status == 'approved'
                            ? Color(0xFF96D165)
                            : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status == 'approved' ? 'Disetujui' : 'Ditolak',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
