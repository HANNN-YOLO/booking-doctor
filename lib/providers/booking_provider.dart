import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class BookingProvider with ChangeNotifier {
  DateTime? selectedDate;
  DateTime? selectedTime;
  TextEditingController iniwaktu = TextEditingController();
  TextEditingController initgl = TextEditingController();

  void tanggal(BuildContext context) async {
    final pilih = await showDatePicker(
      context: context,
      firstDate: DateTime(1),
      lastDate: DateTime(3000),
      initialDate: DateTime.now(),
    );

    if (pilih != null) {
      selectedDate = pilih;
      initgl.text = "${pilih.day.toString().padLeft(2, '0')}-"
          "${pilih.month.toString().padLeft(2, '0')}-"
          "${pilih.year}";
    }
    notifyListeners();
  }

  Future<void> waktu(BuildContext context) async {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: Time(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
        onChange: (Time? pengisian) {
          if (pengisian != null) {
            if (selectedDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Silakan pilih tanggal terlebih dahulu")),
              );
              return;
            }

            this.selectedTime = DateTime(
              selectedDate!.year,
              selectedDate!.month,
              selectedDate!.day,
              pengisian.hour,
              pengisian.minute,
            );

            iniwaktu.text =
                "${pengisian.hour.toString().padLeft(2, '0')}:${pengisian.minute.toString().padLeft(2, '0')}";
            notifyListeners();
          }
        },
        is24HrFormat: true,
        iosStylePicker: true,
        accentColor: Colors.cyan,
      ),
    );
    notifyListeners();
  }

  Future<void> kembali() async {
    if (initgl.text.trim().isNotEmpty && iniwaktu.text.trim().isNotEmpty) {
      initgl.clear();
      iniwaktu.clear();
      selectedDate = null;
      selectedTime = null;
    }
    notifyListeners();
  }
}
