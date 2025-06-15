import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_doctor/providers/profile_provider.dart';

class UdPasien extends StatelessWidget {
  static const arah = 'updatedelete_pasien';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "List Pasien",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future:
            Provider.of<ProfileProvider>(context, listen: false).getPatients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              if (profileProvider.patients.isEmpty) {
                return Center(child: Text('Tidak ada data pasien'));
              }

              return ListView.builder(
                itemCount: profileProvider.patients.length,
                itemBuilder: (context, index) {
                  final patient = profileProvider.patients[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: patient.gambar != null &&
                              patient.gambar!.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(patient.gambar!),
                              radius: 28,
                            )
                          : CircleAvatar(
                              child: Icon(Icons.person),
                              radius: 28,
                            ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(patient.nama ?? 'Nama tidak tersedia'),
                          Text('UID: ${patient.kunci ?? '-'}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700])),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Umur: ${patient.tgllahir != null ? DateTime.now().year - patient.tgllahir!.year : '-'} tahun'),
                          Text('Alamat: ${patient.alamat ?? '-'}'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/read_pasien',
                          arguments: patient.kunci,
                        );
                      },
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
