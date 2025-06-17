import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  static const arah = 'loading';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(Duration(seconds: 3)); // durasi loading
    Navigator.pushReplacementNamed(context, '/login'); // ganti sesuai kebutuhan
    // context.go('/login');
    // Jika ingin mengganti halaman sekarang
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF81C784), // hijau muda, bisa sesuaikan
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
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class LoadingScreen extends StatefulWidget {
//   static const String route = '/loading';

//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen> {
//   @override
//   void initState() {
//     super.initState();

//     // Navigasi setelah frame dibangun (agar context valid)
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _navigateToNext();
//     });
//   }

//   Future<void> _navigateToNext() async {
//     await Future.delayed(Duration(seconds: 3)); // durasi splash
//     context.go('/login'); // arahkan ke halaman login
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF81C784), // hijau muda
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/logo-removebg-preview.png',
//               width: 150,
//               height: 150,
//             ),
//             const SizedBox(height: 20),
//             const CircularProgressIndicator(
//               color: Colors.white,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
