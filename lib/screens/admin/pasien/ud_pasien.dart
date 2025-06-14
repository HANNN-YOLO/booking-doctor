import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../models/daftar.dart';
import '../pasien/read_pasien.dart'; // For future navigation

class UdPasien extends StatelessWidget {
  static const arah = 'updatedelete_pasien';

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        // Data Fetching Logic
        // Check if pasienList is empty, not currently loading, and no error exists.
        // This is a simple way to trigger fetch on initial build or after an error.
        // Consider more sophisticated state management for one-time data fetching in initState if converting to StatefulWidget.
        if (profileProvider.pasienList.isEmpty &&
            !profileProvider.isLoading &&
            profileProvider.error == null) {
          // Use a post-frame callback to avoid calling setState during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            profileProvider.fetchAllPasien(context);
          });
        }

        Widget bodyWidget;

        if (profileProvider.isLoading) {
          bodyWidget = Center(child: CircularProgressIndicator());
        } else if (profileProvider.error != null) {
          bodyWidget = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${profileProvider.error}"),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => profileProvider.fetchAllPasien(context),
                  child: Text("Coba Lagi"),
                ),
              ],
            ),
          );
        } else if (profileProvider.pasienList.isEmpty) {
          bodyWidget = Center(child: Text("Tidak ada data pasien."));
        } else {
          bodyWidget = ListView.builder(
            itemCount: profileProvider.pasienList.length,
            itemBuilder: (context, index) {
              Daftar pasien = profileProvider.pasienList[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(pasien.nama ?? 'Tanpa Nama'),
                subtitle: Text(pasien.email ?? 'Tanpa Email'),
                onTap: () {
                  final selectedPasien = profileProvider.pasienList[index];
                  if (selectedPasien.id != null) {
                    Navigator.pushNamed(
                      context,
                      ReadPasien.arah,
                      arguments: selectedPasien.id,
                    );
                  } else {
                    // Handle the case where ID is null, e.g., show a SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ID pasien tidak ditemukan.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    print('Error: selectedPasien.id is null for ${selectedPasien.nama}');
                  }
                },
              );
            },
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF96D165),
            title: Text(
              "List Pasien",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: bodyWidget,
        );
      },
    );
  }
}
