import 'package:booking_doctor/providers/dokter_provider.dart';
import 'package:booking_doctor/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDokter extends StatefulWidget {
  static const arah = 'create_dokter';

  @override
  State<CreateDokter> createState() => _CreateDokterState();
}

class _CreateDokterState extends State<CreateDokter> {
  final TextEditingController name = TextEditingController();
  final TextEditingController spesialis = TextEditingController();
  final TextEditingController brplama = TextEditingController();
  final TextEditingController hospital = TextEditingController();
  final TextEditingController belajar = TextEditingController();
  final TextEditingController imageurl = TextEditingController();

  // Data untuk jadwal
  final List<String> hariTersedia = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu'
  ];

  final List<String> waktuTersedia = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00'
  ];

  Map<String, List<String>> jadwalDipilih = {};

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DokterProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Tambah Dokter",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: 1100,
            width: 350,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Masukkan Data"),
                Container(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    controller: name,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                      hintText: "Nama Dokter?",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: spesialis,
                    decoration: InputDecoration(
                      hintText: "Spesialis?",
                      hintStyle: TextStyle(color: Colors.grey),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: brplama,
                    decoration: InputDecoration(
                      hintText: "Sudah berapa tahun mengabdi sebagai dokter?",
                      hintStyle: TextStyle(color: Colors.grey),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: hospital,
                    decoration: InputDecoration(
                      hintText: "Rumah Sakit?",
                      hintStyle: TextStyle(color: Colors.grey),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: belajar,
                    decoration: InputDecoration(
                      hintText: "Studi terakhir?",
                      hintStyle: TextStyle(color: Colors.grey),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: TextField(
                    controller: imageurl,
                    decoration: InputDecoration(
                      hintText: "Salin link Gambarnya",
                      hintStyle: TextStyle(color: Colors.grey),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Bagian Jadwal
                Container(
                  width: 300,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jadwal Praktik",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ...hariTersedia.map((hari) {
                        return ExpansionTile(
                          title: Text(hari),
                          children: [
                            Wrap(
                              spacing: 8,
                              children: waktuTersedia.map((waktu) {
                                bool isSelected =
                                    jadwalDipilih[hari]?.contains(waktu) ??
                                        false;
                                return FilterChip(
                                  label: Text(waktu),
                                  selected: isSelected,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        jadwalDipilih[hari] = [
                                          ...(jadwalDipilih[hari] ?? []),
                                          waktu
                                        ];
                                      } else {
                                        jadwalDipilih[hari]?.remove(waktu);
                                        if (jadwalDipilih[hari]?.isEmpty ??
                                            false) {
                                          jadwalDipilih.remove(hari);
                                        }
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          name.clear();
                          spesialis.clear();
                          brplama.clear();
                          hospital.clear();
                          belajar.clear();
                          imageurl.clear();
                          setState(() {
                            jadwalDipilih.clear();
                          });
                        },
                        child: Text(
                          "Hapus",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          // Konversi jadwal yang dipilih ke format AvailableDay
                          final availableDays =
                              jadwalDipilih.entries.map((entry) {
                            // Menghitung tanggal awal minggu (Senin)
                            DateTime now = DateTime.now();
                            DateTime monday =
                                now.subtract(Duration(days: now.weekday - 1));

                            // Menghitung tanggal untuk hari yang dipilih
                            int dayIndex = hariTersedia.indexOf(entry.key);
                            DateTime dayDate =
                                monday.add(Duration(days: dayIndex));

                            return AvailableDay(
                              day: entry.key,
                              weekStartDate: monday,
                              availableTimes: entry.value.map((time) {
                                // Parse waktu dari string ke DateTime
                                List<String> timeParts = time.split(':');
                                int hour = int.parse(timeParts[0]);
                                int minute = int.parse(timeParts[1]);

                                DateTime slotDate = DateTime(
                                  dayDate.year,
                                  dayDate.month,
                                  dayDate.day,
                                  hour,
                                  minute,
                                );

                                return AvailableTime(
                                  time: time,
                                  date: slotDate,
                                  isBooked: false,
                                );
                              }).toList(),
                            );
                          }).toList();

                          // Buat objek Doctor dengan data yang diisi
                          Doctor newDoctor = Doctor(
                            kunci: '', // Akan diisi oleh Firestore
                            id_doctor: DateTime.now().millisecondsSinceEpoch,
                            name: name.text,
                            specialty: spesialis.text,
                            experience: int.parse(brplama.text),
                            hospital: hospital.text,
                            education: belajar.text,
                            availableDays: availableDays,
                            imageUrl: imageurl.text,
                            createdAt: DateTime.now(),
                            updateAt: DateTime.now(),
                          );

                          // Simpan data dokter
                          data.create(
                            newDoctor.name,
                            newDoctor.specialty,
                            newDoctor.hospital,
                            newDoctor.experience,
                            newDoctor.education,
                            availableDays,
                            newDoctor.imageUrl,
                            context,
                          );
                        },
                        child: Text(
                          "Simpan",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
