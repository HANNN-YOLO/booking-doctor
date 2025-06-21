import 'package:booking_doctor/providers/dokter_provider.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Color(0xFFF5F8FA), // Background lebih lembut
      appBar: AppBar(
        elevation: 1, // Bayangan tipis
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Detail Dokter",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(dat.imageUrl),
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 15),
              Text(
                dat.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Spesialisasi : ${dat.specialty}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Pribadi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Divider(height: 25),
                    _buildDetailRow("Pengalaman", "${dat.experience} tahun"),
                    _buildDetailRow("Rumah Sakit", dat.hospital),
                    _buildDetailRow("Pendidikan", dat.education),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat baris detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
