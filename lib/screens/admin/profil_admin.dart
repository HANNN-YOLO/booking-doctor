import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

class ProfilAdmin extends StatelessWidget {
  static const String route = '/profil-admin';

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ProfileProvider>(
      builder: (context, authProvider, profileProvider, child) {
        final userProfile = profileProvider.profileData;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Profil Admin',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF96D165),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Image and Name
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: userProfile?['gambar'] != null
                            ? NetworkImage(userProfile!['gambar'])
                            : null,
                        child: userProfile?['gambar'] == null
                            ? const Icon(Icons.person, size: 60)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userProfile?['nama'] ?? 'Nama Admin',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Edit Profile Button
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/edit-admin'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.edit, color: Colors.grey, size: 24),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Update informasi profil Anda',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // No. HP
                _buildProfileItem(
                  icon: Icons.phone,
                  title: 'No. HP',
                  value: userProfile?['nohp'] ?? '-',
                ),

                // Tanggal Lahir
                _buildProfileItem(
                  icon: Icons.calendar_today,
                  title: 'Tanggal Lahir',
                  value: userProfile?['tgllahir'] != null
                      ? userProfile!['tgllahir'].toString().split(' ')[0]
                      : '-',
                ),

                // Asal
                _buildProfileItem(
                  icon: Icons.location_city,
                  title: 'Asal',
                  value: userProfile?['asal'] ?? '-',
                ),

                // Alamat
                _buildProfileItem(
                  icon: Icons.home,
                  title: 'Alamat',
                  value: userProfile?['alamat'] ?? '-',
                ),

                const SizedBox(height: 20),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await authProvider.logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF96D165),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 24),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
