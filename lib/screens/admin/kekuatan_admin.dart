import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

class kekuatan_admin extends StatelessWidget {
  static const arah = 'kekuatan_admin';
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ProfileProvider>(
      builder: (context, authProvider, profileProvider, child) {
        final user = authProvider.user;
        final userProfile = profileProvider.profileData;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF96D165),
            title: Text(
              "Kekuatan Admin",
              style: TextStyle(color: Colors.white),
            ),
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage('assets/logo-removebg-preview.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
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
                    onTap: () {
                      Navigator.pushNamed(context, '/profil-admin');
                    },
                  ),
                ),
                Container(
                  height: 650,
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text("Pasien"),
                        leading: CircleAvatar(
                          child: Icon(Icons.person_outline),
                        ),
                        onTap: () => Navigator.pushNamed(context, '/read_pasien'),
                      ),
                      ListTile(
                        title: Text("Dokter"),
                        leading: CircleAvatar(
                          child: Icon(Icons.medical_services_outlined),
                        ),
                        onTap: () => Navigator.pushNamed(context, '/updatedelete_dokter'),
                      ),
                      ListTile(
                        title: Text("Persetujuan"),
                        leading: CircleAvatar(
                          child: Icon(Icons.approval),
                        ),
                        onTap: () => Navigator.pushNamed(context, '/persetujuan'),
                      ),
                      ListTile(
                        title: Text("History"),
                        leading: CircleAvatar(
                          child: Icon(Icons.history),
                        ),
                        onTap: () => Navigator.pushNamed(context, '/history_admin'),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 35),
                  child: ListTile(
                    title: Text("Log Out"),
                    leading: CircleAvatar(
                      child: Icon(Icons.logout),
                    ),
                    onTap: () async {
                      await authProvider.logout(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
