import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import 'edit_profil_pasien.dart';
import 'package:intl/intl.dart';

class ProfilPasien extends StatelessWidget {
  static const arah = 'profil_pasien';
  const ProfilPasien({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ProfileProvider>(
      builder: (context, authProvider, profileProvider, child) {
        final profileData = profileProvider.profileData;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: profileData == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Header dengan background hijau
                    Container(
                      padding: const EdgeInsets.only(top: 50, bottom: 20),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF96D165),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Profil Saya',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            // Foto profil
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: profileData['gambar'] != null &&
                                      profileData['gambar'].isNotEmpty
                                  ? NetworkImage(profileData['gambar'])
                                      as ImageProvider
                                  : const NetworkImage(
                                      'https://picsum.photos/id/15/200/300'),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              profileData['nama'] ?? 'Nama Pasien',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Edit Profile Button
                            _buildListTile(
                              icon: Icons.edit,
                              title: 'Edit Profile',
                              subtitle: 'Update informasi profil Anda',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilPasien(),
                                  ),
                                );
                              },
                            ),
                            // Nomor HP
                            _buildListTile(
                              icon: Icons.phone,
                              title: 'No. HP',
                              subtitle: profileData['nohp']?.toString() ?? '-',
                            ),
                            // Tanggal Lahir
                            _buildListTile(
                              icon: Icons.calendar_today,
                              title: 'Tanggal Lahir',
                              subtitle: profileData['tgllahir'] != null
                                  ? DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(profileData['tgllahir']))
                                  : '-',
                            ),
                            // Asal
                            _buildListTile(
                              icon: Icons.location_city,
                              title: 'Asal',
                              subtitle: profileData['asal'] ?? '-',
                            ),
                            // Alamat
                            _buildListTile(
                              icon: Icons.home,
                              title: 'Alamat',
                              subtitle: profileData['alamat'] ?? '-',
                            ),
                            const SizedBox(height: 20),
                            // Tombol Log Out
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle logout
                                  authProvider.logout(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF96D165),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom Navigation
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 1,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            backgroundColor: Colors.blue[700],
            onTap: (index) {
              if (index == 0) {
                Navigator.pushNamed(context, '/');
              } else if (index == 1) {
                Navigator.pushNamed(context, '/profil_pasien');
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF96D165)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
