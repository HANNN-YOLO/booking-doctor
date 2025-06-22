import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Menggunakan addPostFrameCallback untuk memastikan navigasi terjadi setelah build selesai.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              Navigator.pushReplacementNamed(
                  context, '/'); // Pengguna login, ke halaman utama
            } else {
              Navigator.pushReplacementNamed(
                  context, '/login'); // Pengguna tidak login, ke halaman login
            }
          }
        });

        // Tampilan loading, akan terlihat sebentar sebelum navigasi
        return Scaffold(
          backgroundColor: Color(0xFF81C784),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo-removebg-preview.png',
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
