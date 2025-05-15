import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class BookingProvider with ChangeNotifier {
  DateTime? selectedDate;
  DateTime? selectedTime;
  TextEditingController iniwaktu = TextEditingController();
  TextEditingController initgl = TextEditingController();

  Future<void> waktu(BuildContext context) async {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: Time(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
        // value: DateFormat('HH:mm').format(waktu),
        onChange: (Time? pengisian) {
          if (pengisian != null) {
            final isi = DateTime.now();
            this.selectedTime = DateTime(
              isi.day,
              isi.month,
              isi.year,
              pengisian.hour,
              pengisian.minute,
            );
            iniwaktu.text =
                "${pengisian.hour.toString().padLeft(2, '0')}: ${pengisian.minute.toString().padLeft(2, '0')}";
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

  void tanggal(BuildContext context) async {
    final pilih = await showDatePicker(
      context: context,
      firstDate: DateTime(1),
      lastDate: DateTime(3000),
      initialDate: DateTime.now(),
    );

    if (pilih != null) {
      initgl.text = "${pilih.day.toString().padLeft(2, '0')}-"
          "${pilih.month.toString().padLeft(2, '0')}-"
          "${pilih.year}";
    }
    notifyListeners();
  }
}
