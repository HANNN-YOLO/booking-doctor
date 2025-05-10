import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/doctor_card.dart';
import '/screens/doctor_detail_screen.dart';
import '/screens/history_screen.dart';

class SearchScreen extends StatelessWidget {
  static const routing = 'cari';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari Dokter'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(HistoryScreen.routing);
              },
              icon: Icon(Icons.history))
        ],
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            items: ['Umum', 'Gigi', 'Anak'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text("Pilih Spesialisasi"),
            onChanged: (value) {},
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return DoctorCard(
                  name: "Dr. Contoh $index",
                  specialty: "Spesialis Umum",
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(DoctorDetailScreen.routing);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
