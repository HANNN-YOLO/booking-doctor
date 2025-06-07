import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../widgets/doctor_schedule_calendar.dart';
import '../services/doctor_schedule_service.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorDetailScreen({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final DoctorScheduleService _scheduleService = DoctorScheduleService();

  void _handleTimeSlotSelected(DateTime date, String time) async {
    try {
      // Cek apakah slot masih tersedia
      final isAvailable = await _scheduleService.isTimeSlotAvailable(
        widget.doctor.kunci,
        date,
        time,
      );

      if (!isAvailable) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maaf, jadwal ini sudah tidak tersedia'),
          ),
        );
        return;
      }

      // Tampilkan dialog konfirmasi
      if (!mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konfirmasi Booking'),
          content: Text(
            'Anda akan membuat janji dengan ${widget.doctor.name}\n'
            'Pada: ${date.day}/${date.month}/${date.year}\n'
            'Jam: $time',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      // Proses booking
      await _scheduleService.bookTimeSlot(
        widget.doctor.kunci,
        'current_user_id', // TODO: Ganti dengan ID user yang sedang login
        date,
        time,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking berhasil! Menunggu konfirmasi admin'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal melakukan booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor.name),
      ),
      body: Column(
        children: [
          // Informasi Dokter
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.doctor.imageUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctor.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        widget.doctor.specialty,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        '${widget.doctor.experience} tahun pengalaman',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        widget.doctor.hospital,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Kalender Jadwal
          Expanded(
            child: DoctorScheduleCalendar(
              doctor: widget.doctor,
              onTimeSlotSelected: _handleTimeSlotSelected,
            ),
          ),
        ],
      ),
    );
  }
}
