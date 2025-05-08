import 'package:flutter/material.dart';
import '../widgets/doctor_card.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cari Dokter')),
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
                    Navigator.pushNamed(context, '/detail');
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
