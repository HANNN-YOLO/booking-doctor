import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_doctor/providers/profile_provider.dart';

class UdPasien extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Daftar Pasien",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Provider.of<ProfileProvider>(context, listen: false)
            .getAllPatientsList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final patients = snapshot.data ?? [];
          if (patients.isEmpty) {
            return Center(child: Text('Belum ada pasien terdaftar'));
          }

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              print('ID pasien yang dikirim: ${patient['id']}');
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: patient['gambar'] != null &&
                            patient['gambar'].toString().isNotEmpty
                        ? NetworkImage(patient['gambar'])
                        : null,
                    child: patient['gambar'] == null ||
                            patient['gambar'].toString().isEmpty
                        ? Icon(Icons.person)
                        : null,
                  ),
                  title: Text(
                    patient['nama'] ?? patient['name'] ?? '-',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(patient['email'] ?? '-'),
                      Text(patient['nohp']?.toString() ??
                          patient['phone'] ??
                          '-'),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/read_pasien',
                      arguments: patient['id'],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
