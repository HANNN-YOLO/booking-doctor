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
                      title: Text(patient['name'] ?? 'Nama tidak tersedia'),
                      subtitle:
                          Text(patient['email'] ?? 'Email tidak tersedia'),
                      trailing: Icon(Icons.arrow_forward_ios),
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
          );
        },
      ),
    );
  }
}
