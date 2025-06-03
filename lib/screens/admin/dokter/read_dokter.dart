import 'package:booking_doctor/providers/dokter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ReadDokter extends StatelessWidget {
  static const arah = 'read_dokter';
  @override
  Widget build(BuildContext context) {
    final isi = ModalRoute.of(context)?.settings.arguments as String;
    final dat = Provider.of<DokterProvider>(context)
        .dumydata
        .firstWhere((dat) => dat.kunci == isi);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Detail Dokter ${dat.kunci}",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: NetworkImage("${dat.imageUrl}"),
                      fit: BoxFit.cover)),
            ),
            Container(
              height: 380,
              child: ListView(
                children: [
                  ListTile(
                      title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama : ${dat.name}"),
                      Text("Spesialis : ${dat.specialty}"),
                      Text("Pengalaman : ${dat.experience}"),
                      Text("Rumah Sakit : ${dat.hospital}"),
                      Text("Pendidikan Terakhir: ${dat.education}")
                    ],
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
