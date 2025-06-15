import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

class kekuatan_admin extends StatefulWidget {
  static const arah = 'kekuatan_admin';

  @override
  _KekuatanAdminState createState() => _KekuatanAdminState();
}

class _KekuatanAdminState extends State<kekuatan_admin> {
  int _adminCount = 0;
  int _pasienCount = 0;
  int _dokterCount = 0;
  int _acceptedBookingsCount = 0;
  int _rejectedBookingsCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final adminSnapshot =
          await FirebaseDatabase.instance.ref('admin_profiles').get();
      _adminCount = adminSnapshot.exists ? adminSnapshot.children.length : 0;

      final pasienSnapshot =
          await FirebaseDatabase.instance.ref('pasien_profiles').get();
      _pasienCount = pasienSnapshot.exists ? pasienSnapshot.children.length : 0;

      final dokterSnapshot =
          await FirebaseFirestore.instance.collection('doctor').get();
      _dokterCount = dokterSnapshot.docs.length;

      final acceptedBookingsSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('status', isEqualTo: 'confirmed')
          .get();
      _acceptedBookingsCount = acceptedBookingsSnapshot.docs.length;

      final rejectedBookingsSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('status', isEqualTo: 'cancelled')
          .get();
      _rejectedBookingsCount = rejectedBookingsSnapshot.docs.length;
    } catch (e) {
      print('Fetch error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(count.toString(),
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ProfileProvider>(
      builder: (context, authProvider, profileProvider, child) {
        final userProfile = profileProvider.profileData;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF96D165),
            title:
                Text("Kekuatan Admin", style: TextStyle(color: Colors.white)),
            leading: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo-removebg-preview.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(Icons.menu, color: Colors.white),
                ),
              ),
            ],
          ),
          drawer: Drawer(
            width: 200,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 35),
                  child: ListTile(
                    title: Text(userProfile?['nama'] ?? "Admin"),
                    leading: CircleAvatar(
                      backgroundImage: userProfile?['gambar'] != null
                          ? NetworkImage(userProfile!['gambar'])
                          : null,
                      child: userProfile?['gambar'] == null
                          ? Icon(Icons.person)
                          : null,
                    ),
                    onTap: () => Navigator.pushNamed(context, '/profil-admin'),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text("Pasien"),
                        leading:
                            CircleAvatar(child: Icon(Icons.person_outline)),
                        onTap: () =>
                            Navigator.pushNamed(context, '/read_pasien'),
                      ),
                      ListTile(
                        title: Text("Dokter"),
                        leading: CircleAvatar(
                            child: Icon(Icons.medical_services_outlined)),
                        onTap: () => Navigator.pushNamed(
                            context, '/updatedelete_dokter'),
                      ),
                      ListTile(
                        title: Text("Persetujuan"),
                        leading: CircleAvatar(child: Icon(Icons.approval)),
                        onTap: () =>
                            Navigator.pushNamed(context, '/persetujuan'),
                      ),
                      ListTile(
                        title: Text("History"),
                        leading: CircleAvatar(child: Icon(Icons.history)),
                        onTap: () =>
                            Navigator.pushNamed(context, '/history_admin'),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text("Log Out"),
                  leading: CircleAvatar(child: Icon(Icons.logout)),
                  onTap: () async => await authProvider.logout(context),
                ),
              ],
            ),
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildStatCard("Jumlah Admin", _adminCount,
                          Icons.admin_panel_settings, Colors.blue),
                      _buildStatCard("Jumlah Pasien", _pasienCount,
                          Icons.people, Colors.green),
                      _buildStatCard("Jumlah Dokter", _dokterCount,
                          Icons.medical_services, Colors.orange),
                      _buildStatCard("Booking Diterima", _acceptedBookingsCount,
                          Icons.check_circle, Colors.teal),
                      _buildStatCard("Booking Ditolak", _rejectedBookingsCount,
                          Icons.cancel, Colors.red),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
