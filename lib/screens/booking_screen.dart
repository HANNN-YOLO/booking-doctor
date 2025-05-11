import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../providers/booking_provider.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class BookingScreen with ChangeNotifier {
  final TextEditingController tgl = TextEditingController();
  final TextEditingController waktu = TextEditingController();

  void tanggal(BuildContext context) async {
    final pilih = await showDatePicker(
      context: context,
      firstDate: DateTime(1),
      lastDate: DateTime(3000),
      initialDate: DateTime.now(),
    );

    if (pilih != null) {
      tgl.text = "${pilih.day.toString().padLeft(2, '0')}-"
          "${pilih.month.toString().padLeft(2, '0')}-"
          "${pilih.year}";
    }
    notifyListeners();
  }

  // void waktu(BuildContext context) async {
  //   DateTime selectedTime = DateTime.now();
  //   final choices = await TimePickerSpinner(
  //     is24HourMode: true,
  //     normalTextStyle: TextStyle(fontSize: 20, color: Colors.deepOrange),
  //     highlightedTextStyle: TextStyle(fontSize: 20, color: Colors.cyan),
  //     spacing: 50,
  //     itemHeight: 80,
  //     isForce2Digits: true,
  //     onTimeChange: (time) {
  //       selectedTime = time;
  //     },
  //   );

  //   if (choices != null) {
  //     pengisian.text = "${choices.hour}"
  //   }

  // await showTimePicker(
  //   context: context,
  //   initialTime: TimeOfDay.now(),
  // );
  // }

  // void updateWaktuText(BuildContext context, DateTime waktu) {
  //   pengisian.text =
  //       "${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}";
  //   notifyListeners();
  // }

  void pilihWaktu(BuildContext context) {
    DateTime selectedTime = DateTime.now();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 370,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text("Pilih Waktu",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TimePickerSpinner(
                is24HourMode: true,
                normalTextStyle:
                    TextStyle(fontSize: 20, color: Colors.deepOrange),
                highlightedTextStyle:
                    TextStyle(fontSize: 20, color: Colors.cyan),
                spacing: 50,
                itemHeight: 80,
                isForce2Digits: true,
                onTimeChange: (time) {
                  selectedTime = time;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  final timeText =
                      "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
                  waktu.text = timeText;
                  Navigator.of(context).pop();

                  // updateWaktuText(context, selectedTime);
                  // Navigator.pop(context);
                },
                child: Text("Pilih"),
              ),
            ],
          ),
        );
      },
    );
  }

  void pesan_booking_screen(BuildContext context) {
    // final provider = Provider.of<BookingProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Booking Docter"),
                    TextField(
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                      controller: tgl,
                      onTap: () => tanggal(context),
                      onSubmitted: (_) => tanggal(context),
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.zero),
                        hintText: "Pilih Tanggal",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.date_range),
                      ),
                    ),
                    TextField(
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                      controller: waktu,
                      onTap: () => pilihWaktu(context),
                      onSubmitted: (_) => pilihWaktu(context),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          hintText: "Pilih Jam",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Padding(
                              padding: EdgeInsets.all(12),
                              child: FaIcon(FontAwesomeIcons.clock))),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Kembali",
                                style: TextStyle(color: Colors.white),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  backgroundColor: Colors.cyan),
                              onPressed: () {},
                              child: Text(
                                "Buat",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
