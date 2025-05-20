import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:booking_doctor/providers/booking_provider.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../providers/booking_provider.dart';

class BookingScreen with ChangeNotifier {
  void pesan_booking_screen(BuildContext context) {
    // final provider = Provider.of<BookingProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                height: 300,
                child: Consumer<BookingProvider>(
                  builder: (context, value, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Booking Docter"),
                      TextField(
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        controller: value.initgl,
                        onTap: () => value.tanggal(context),
                        onSubmitted: (_) => value.tanggal(context),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero),
                          hintText: "Pilih Tanggal",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.date_range),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        controller: value.iniwaktu,
                        onTap: () => value.waktu(context),
                        onSubmitted: (_) => value.waktu(context),
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
                                  value.kembali();
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
              ),
            ));
  }
}
