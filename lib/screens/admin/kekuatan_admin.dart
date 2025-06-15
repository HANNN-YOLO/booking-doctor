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
  int _pendingBookingsCount = 0;
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

      final pendingBookingsSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('status', isEqualTo: 'pending')
          .get();
      _pendingBookingsCount = pendingBookingsSnapshot.docs.length;
    } catch (e) {
      print('Fetch error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildStatCard(
      String title, int count, IconData icon, Color color, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
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
                  textAlign:
                      TextAlign.center, // Ensure text is centered if it wraps
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(count.toString(),
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
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
            leading: Container(),
            title:
                Text("Dashboard Admin", style: TextStyle(color: Colors.white)),
            actions: [
              Builder(
                builder: (context) => Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo-removebg-preview.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
            // actions removed
          ),
          // drawer removed
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: Color(0xFF96D165),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text(userProfile?['nama'] ?? "Admin",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: userProfile?['gambar'] != null
                                ? NetworkImage(userProfile!['gambar'])
                                : null,
                            child: userProfile?['gambar'] == null
                                ? Icon(Icons.person, size: 30)
                                : null,
                          ),
                          onTap: () =>
                              Navigator.pushNamed(context, '/profil-admin'),
                        ),
                        SizedBox(height: 16), // Add some spacing
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          shrinkWrap:
                              true, // Important for GridView inside Column/ListView
                          physics:
                              NeverScrollableScrollPhysics(), // Important for scroll behavior
                          children: [
                            _buildStatCard(
                                "Edit Profil Admin",
                                _adminCount,
                                Icons.person,
                                Colors.blue,
                                () => Navigator.pushNamed(context,
                                    '/profil_admin') // Example, might need a dedicated admin list screen
                                ),
                            _buildStatCard("Jumlah Pasien", _pasienCount,
                                Icons.people, Colors.green, () {
                              Navigator.pushNamed(
                                context,
                                '/updatedelete_pasien',
                              );
                            }),
                            _buildStatCard(
                                "Jumlah Dokter",
                                _dokterCount,
                                Icons.medical_services,
                                Colors.orange,
                                () => Navigator.pushNamed(
                                    context, '/updatedelete_dokter')),
                            _buildStatCard(
                                "Jumlah Persetujuan",
                                _pendingBookingsCount,
                                Icons.approval,
                                Colors.purple,
                                () => Navigator.pushNamed(
                                    context, '/persetujuan')),
                            _buildStatCard(
                                "Booking Diterima",
                                _acceptedBookingsCount,
                                Icons.check_circle,
                                Colors.teal,
                                () => Navigator.pushNamed(
                                    context, '/history_admin')),
                            _buildStatCard(
                                "Booking Ditolak",
                                _rejectedBookingsCount,
                                Icons.cancel,
                                Colors.red,
                                () => Navigator.pushNamed(
                                    context, '/history_admin')),
                          ],
                        ),
                        SizedBox(height: 30), // Add some spacing
                        ListTile(
                          tileColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text(
                            "Log Out",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: CircleAvatar(child: Icon(Icons.logout)),
                          onTap: () async => await authProvider.logout(context),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
