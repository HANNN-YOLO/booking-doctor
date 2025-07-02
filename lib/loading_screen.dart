import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Logout otomatis setiap aplikasi dibuka
    FirebaseAuth.instance.signOut();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Menggunakan addPostFrameCallback untuk memastikan navigasi terjadi setelah build selesai.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Karena sudah signOut, user pasti belum login
            Navigator.pushReplacementNamed(context, '/login');
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
