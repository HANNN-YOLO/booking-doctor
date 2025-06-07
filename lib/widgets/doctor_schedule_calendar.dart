import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/doctor.dart';
import '../services/doctor_schedule_service.dart';

class DoctorScheduleCalendar extends StatefulWidget {
  final Doctor doctor;
  final Function(DateTime date, String time) onTimeSlotSelected;

  const DoctorScheduleCalendar({
    Key? key,
    required this.doctor,
    required this.onTimeSlotSelected,
  }) : super(key: key);

  @override
  State<DoctorScheduleCalendar> createState() => _DoctorScheduleCalendarState();
}

class _DoctorScheduleCalendarState extends State<DoctorScheduleCalendar> {
  final DoctorScheduleService _scheduleService = DoctorScheduleService();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<AvailableTime> _availableSlots = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadScheduleForWeek(_focusedDay);
  }

  Future<void> _loadScheduleForWeek(DateTime weekOf) async {
    setState(() => _isLoading = true);
    try {
      final slots = await _scheduleService.getDoctorScheduleForWeek(
        widget.doctor.kunci,
        weekOf,
      );
      setState(() => _availableSlots = slots);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat jadwal: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<AvailableTime> _getAvailableSlotsForDay(DateTime day) {
    return _availableSlots
        .where((slot) =>
            slot.date.year == day.year &&
            slot.date.month == day.month &&
            slot.date.day == day.day)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 30)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.week,
          availableGestures: AvailableGestures.all,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            _loadScheduleForWeek(focusedDay);
          },
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const CircularProgressIndicator()
        else if (_selectedDay != null)
          Expanded(
            child: _buildTimeSlots(_selectedDay!),
          ),
      ],
    );
  }

  Widget _buildTimeSlots(DateTime selectedDate) {
    final slots = _getAvailableSlotsForDay(selectedDate);

    if (slots.isEmpty) {
      return const Center(
        child: Text('Tidak ada jadwal tersedia untuk tanggal ini'),
      );
    }

    return ListView.builder(
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(slot.time),
            trailing: slot.isBooked
                ? const Chip(
                    label: Text('Sudah Dibooking'),
                    backgroundColor: Colors.red,
                  )
                : ElevatedButton(
                    onPressed: () =>
                        widget.onTimeSlotSelected(slot.date, slot.time),
                    child: const Text('Pilih Jadwal'),
                  ),
          ),
        );
      },
    );
  }
}
