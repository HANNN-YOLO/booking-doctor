import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import 'package:intl/intl.dart';

class HistoryBookingScreen extends StatelessWidget {
  static const String routeName = '/history-booking';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              Tab(text: 'Menunggu'),
              Tab(text: 'Disetujui'),
              Tab(text: 'Ditolak'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingHistoryList(status: 'pending'),
            _BookingHistoryList(status: 'confirmed'),
            _BookingHistoryList(status: 'cancelled'),
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
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        return StreamBuilder<List<Booking>>(
          stream: status == 'pending'
              ? bookingProvider.getCurrentUserBookings()
              : status == 'confirmed'
                  ? bookingProvider.getCurrentUserConfirmedBookings()
                  : bookingProvider.getCurrentUserCancelledBookings(),
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
                  status == 'confirmed'
                      ? 'Belum ada booking yang disetujui'
                      : status == 'cancelled'
                          ? 'Belum ada booking yang ditolak'
                          : 'Belum ada booking yang menunggu persetujuan',
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
                      backgroundColor: _getStatusColor(status),
                      child: Icon(
                        Icons.medical_services,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'ID Dokter: ${booking.doctorId}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_formatDate(booking.bookingDate)}, ${booking.time}',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Dibuat pada: ${_formatDateTime(booking.createdAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        if (status == 'pending')
                          Text(
                            'Menunggu persetujuan admin',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                              fontStyle: FontStyle.italic,
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
                        color: _getStatusColor(status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(status),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Color(0xFF96D165);
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'Disetujui';
      case 'cancelled':
        return 'Ditolak';
      case 'pending':
        return 'Menunggu';
      default:
        return '';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
