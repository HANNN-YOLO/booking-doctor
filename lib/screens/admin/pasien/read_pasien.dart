import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_doctor/providers/profile_provider.dart';

class ReadPasien extends StatelessWidget {
  int? hitungUmur(String? tgllahir) {
    if (tgllahir == null || tgllahir.isEmpty) return null;
    try {
      final tgl = DateTime.parse(tgllahir.split('T').first);
      final now = DateTime.now();
      int umur = now.year - tgl.year;
      if (now.month < tgl.month ||
          (now.month == tgl.month && now.day < tgl.day)) {
        umur--;
      }
      return umur;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? patientId =
        ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Detail Pasien",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: patientId == null
          ? Center(child: Text('ID Pasien tidak ditemukan'))
          : FutureBuilder<Map<String, dynamic>?>(
              future: Provider.of<ProfileProvider>(context, listen: false)
                  .getPatientById(patientId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final patientData = snapshot.data;
                if (patientData == null) {
                  return Center(child: Text('Data pasien tidak ditemukan'));
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: patientData['gambar'] != null &&
                                patientData['gambar'].toString().isNotEmpty
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(patientData['gambar']),
                                radius: 48,
                              )
                            : CircleAvatar(
                                child: Icon(Icons.person, size: 48),
                                radius: 48,
                              ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Informasi Pribadi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              SizedBox(height: 16),
                              // _buildInfoRow(
                              //     'ID Pasien', patientData['id'] ?? '-'),
                              _buildInfoRow(
                                  'Nama',
                                  patientData['nama'] ??
                                      patientData['name'] ??
                                      '-'),
                              _buildInfoRow(
                                  'Email', patientData['email'] ?? '-'),
                              _buildInfoRow(
                                  'Telepon',
                                  patientData['nohp']?.toString() ??
                                      patientData['phone'] ??
                                      '-'),
                              _buildInfoRow(
                                  'Alamat',
                                  patientData['alamat'] ??
                                      patientData['address'] ??
                                      '-'),
                              _buildInfoRow('Tanggal Lahir',
                                  patientData['tgllahir'] ?? '-'),
                              _buildInfoRow('Usia',
                                  '${hitungUmur(patientData['tgllahir']) ?? '-'} tahun'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Card(
                      //   child: Padding(
                      //     padding: EdgeInsets.all(16),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           'Informasi Medis',
                      //           style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.blue[800],
                      //           ),
                      //         ),
                      //         SizedBox(height: 16),
                      //         _buildInfoRow('Golongan Darah',
                      //             patientData['golongan_darah'] ?? '-'),
                      //         _buildInfoRow('Riwayat Penyakit',
                      //             patientData['riwayat_penyakit'] ?? '-'),
                      //         _buildInfoRow(
                      //             'Alergi', patientData['alergi'] ?? '-'),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
