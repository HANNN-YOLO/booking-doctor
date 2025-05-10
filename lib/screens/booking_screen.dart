import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import '../providers/booking_provider.dart';

// Cara 1 tetap masih dalam keadaan screen
// class BookingScreen extends StatelessWidget {
//   static const routing = 'booking';
//   @override
//   Widget build(BuildContext context) {
//     // final provider = Provider.of<BookingProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: Text("Booking Janji")),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () async {
//               final date = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime.now(),
//                 lastDate: DateTime(2100),
//               );
//               // if (date != null) {
//               //   provider.setDateTime(date);
//               // }
//             },
//             child: Text("Pilih Tanggal"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Konfirmasi
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Booking dikonfirmasi")),
//               );
//             },
//             child: Text("Konfirmasi Booking"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Penutup Cara 1

// Cara 2 kita jadikan ini class nya ubah jadi sebuah Fungsi
void isi(BuildContext context) async {
  final pilih = await showDatePicker(
      context: context, firstDate: DateTime(1), lastDate: DateTime(3000));
}

void pesan_booking_screeen(BuildContext context) {
  // final TextEditingController pengisian = TextEditingController();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Booking Docter"),
                  TextField(
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () => isi(context),
                    // controller: pengisian,
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
// }

// Penutup Cara 2
