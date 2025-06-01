import 'package:booking_doctor/providers/dokter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CreateDokter extends StatelessWidget {
  static const arah = 'create_dokter';

  final TextEditingController name = TextEditingController();
  final TextEditingController spesialis = TextEditingController();
  final TextEditingController brplama = TextEditingController();
  final TextEditingController hospital = TextEditingController();
  final TextEditingController belajar = TextEditingController();
  final TextEditingController imageurl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DokterProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Tambah DOkter",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          height: 700,
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    hintText: "Nama Dokter?",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: spesialis,
                  decoration: InputDecoration(
                    hintText: "Spesialis?",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: brplama,
                  decoration: InputDecoration(
                    hintText: "Sudah berapa tahun mengabdi sebagai dokter?",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: hospital,
                  decoration: InputDecoration(
                    hintText: "Rumah Sakit?",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: belajar,
                  decoration: InputDecoration(
                    hintText: "Studi terakhir?",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: imageurl,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    // data.create(
                    //   name.text,
                    //   posisition.text,
                    //   imageurl.text,
                    //   context,
                    // );
                  },
                  decoration: InputDecoration(
                    hintText: "Salin link Gambarnya",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
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
                        belajar.clear();
                        imageurl.clear();
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
                      onPressed: () async {
                        data.create(name.text, spesialis.text, hospital.text,
                            brplama.text, belajar.text, imageurl.text, context);
                      },
                      child: Text(
                        "POST",
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
    );
  }
}
