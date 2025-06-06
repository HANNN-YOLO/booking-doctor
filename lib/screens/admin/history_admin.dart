import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import 'package:intl/intl.dart';

class HistoryAdmin extends StatelessWidget {
  static const arah = 'history_admin';

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF96D165),
          title: Text(
            "Riwayat Booking",
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
            _BookingHistoryList(
                status: 'approved',
                formatDate: _formatDate,
                formatDateTime: _formatDateTime),
            _BookingHistoryList(
                status: 'rejected',
                formatDate: _formatDate,
                formatDateTime: _formatDateTime),
          ],
        ),
      ),
    );
  }
}

class _BookingHistoryList extends StatelessWidget {
  final String status;
  final String Function(DateTime) formatDate;
  final String Function(DateTime) formatDateTime;

  const _BookingHistoryList({
    Key? key,
    required this.status,
    required this.formatDate,
    required this.formatDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        return StreamBuilder<List<Booking>>(
          stream: status == 'approved'
              ? bookingProvider.approvedBookings
              : bookingProvider.rejectedBookings,
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
                  child: Text(status == 'approved'
                      ? 'Belum ada riwayat booking yang disetujui'
                      : 'Belum ada riwayat booking yang ditolak'));
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
                                    'Pasien: ${booking.patientName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Dokter ${booking.doctorName}',
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
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Spesialis: ${booking.specialty}'),
                        Text(
                          'Jadwal: ${formatDate(booking.selectedDate)}, ${booking.selectedTime}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (status == 'approved' && booking.approvedAt != null)
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'Disetujui pada: ${formatDateTime(booking.approvedAt!)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        if (status == 'rejected')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (booking.rejectedAt != null)
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Ditolak pada: ${formatDateTime(booking.rejectedAt!)}',
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
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
