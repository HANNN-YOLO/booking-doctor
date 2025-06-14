import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/profile_provider.dart';
// import '../../../models/daftar.dart'; // Not strictly needed if ProfileProvider.profileData is Map

class ReadPasien extends StatefulWidget {
  static const arah = 'read_pasien';
  final String patientId;

  ReadPasien({required this.patientId});

  @override
  _ReadPasienState createState() => _ReadPasienState();
}

class _ReadPasienState extends State<ReadPasien> {
  @override
  void initState() {
    super.initState();
    // Fetch patient details when the widget is initialized
    // Use addPostFrameCallback to ensure context is available and provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false)
          .loadPasienProfileById(widget.patientId, context);
    });
  }

  Widget _buildListTile(String title, String? subtitle, IconData icon) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF96D165)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle ?? 'Tidak tersedia',
            style: TextStyle(fontSize: 16.0)),
      ),
    );
  }

  String _formatTanggal(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'Tidak tersedia';
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return 'Format tanggal salah';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Detail Pasien",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (profileProvider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${profileProvider.error}", textAlign: TextAlign.center),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        profileProvider.loadPasienProfileById(widget.patientId, context);
                      },
                      child: Text("Coba Lagi"),
                    )
                  ],
                ),
              )
            );
          }

          final profileData = profileProvider.profileData;

          if (profileData == null) {
            return Center(child: Text("Profil pasien tidak ditemukan."));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: profileData['gambar'] != null && profileData['gambar'].isNotEmpty
                      ? NetworkImage(profileData['gambar'])
                      : null,
                  child: profileData['gambar'] == null || profileData['gambar'].isEmpty
                      ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                      : null,
                ),
                SizedBox(height: 16.0),
                Text(
                  profileData['nama'] ?? 'Tanpa Nama',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.0),
                _buildListTile('No. HP', profileData['nohp'], Icons.phone),
                _buildListTile('Tanggal Lahir', _formatTanggal(profileData['tgllahir']), Icons.calendar_today),
                _buildListTile('Usia', profileData['usia']?.toString() ?? 'Tidak tersedia', Icons.cake),
                _buildListTile('Asal', profileData['asal'], Icons.location_city),
                _buildListTile('Alamat', profileData['alamat'], Icons.home),
                _buildListTile('Email', profileData['email'], Icons.email),
              ],
            ),
          );
        },
      ),
    );
  }
}
