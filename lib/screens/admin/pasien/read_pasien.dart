import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_doctor/providers/profile_provider.dart';

class ReadPasien extends StatelessWidget {
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
                              _buildInfoRow('Nama', patientData['name'] ?? '-'),
                              _buildInfoRow(
                                  'Email', patientData['email'] ?? '-'),
                              _buildInfoRow(
                                  'Telepon', patientData['phone'] ?? '-'),
                              _buildInfoRow(
                                  'Alamat', patientData['address'] ?? '-'),
                              _buildInfoRow('Tanggal Lahir',
                                  patientData['tgllahir'] ?? '-'),
                              _buildInfoRow('Usia',
                                  '${patientData['usia'] ?? '-'} tahun'),
                            ],
                          ),
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
                                'Informasi Medis',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              SizedBox(height: 16),
                              _buildInfoRow('Golongan Darah',
                                  patientData['golongan_darah'] ?? '-'),
                              _buildInfoRow('Riwayat Penyakit',
                                  patientData['riwayat_penyakit'] ?? '-'),
                              _buildInfoRow(
                                  'Alergi', patientData['alergi'] ?? '-'),
                            ],
                          ),
                        ),
                      ),
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
