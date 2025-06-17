import 'package:booking_doctor/providers/dokter_provider.dart';
import 'package:booking_doctor/screens/main/profil_pasien.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Providers
import 'providers/booking_provider.dart';
import 'providers/search_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';

// Main Screens
import 'loading_screen.dart';
import 'screens/main/search_screen.dart';
import 'screens/main/doctor_detail_screen.dart';
import 'screens/main/history_screen.dart';
import 'screens/main/chat_screen.dart';
import 'screens/main/notifikasi.dart';
import 'screens/main/history_booking.dart';

// Auth Screens
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';

// Admin Screens
import 'screens/admin/kekuatan_admin.dart';
import 'screens/admin/profil_admin.dart';
import 'screens/admin/edit_admin.dart';
import 'screens/admin/dokter/create_dokter.dart';
import 'screens/admin/dokter/read_dokter.dart';
import 'screens/admin/dokter/ud_dokter.dart';
import 'screens/admin/pasien/read_pasien.dart';
import 'screens/admin/pasien/ud_pasien.dart';
import 'screens/admin/history_admin.dart';
import 'screens/admin/persetujuan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookingProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => DokterProvider(context)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Booking Dokter',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/loading',
        routes: {
          '/loading': (context) => LoadingScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/': (context) => SearchScreen(),
          '/detail': (context) => DoctorDetailScreen(),
          '/history': (context) => HistoryScreen(),
          '/notifikasi': (context) => NotifikasiScreen(),
          '/history-booking': (context) => HistoryBookingScreen(),
          '/chat': (context) => ChatScreen(),
          '/profil_pasien': (context) => ProfilPasien(),
          '/kekuatan_admin': (context) => kekuatan_admin(),
          '/profil-admin': (context) => ProfilAdmin(),
          '/edit-admin': (context) => EditAdmin(),
          '/updatedelete_dokter': (context) => UdDokter(),
          '/read_dokter': (context) => ReadDokter(),
          '/create_dokter': (context) => CreateDokter(),
          '/updatedelete_pasien': (context) => UdPasien(),
          '/read_pasien': (context) => ReadPasien(),
          '/persetujuan': (context) => Persetujuan(),
          '/history_admin': (context) => HistoryAdmin(),
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';

// // Providers
// import 'providers/booking_provider.dart';
// import 'providers/search_provider.dart';
// import 'providers/chat_provider.dart';
// import 'providers/auth_provider.dart';
// import 'providers/profile_provider.dart';
// import 'providers/dokter_provider.dart';

// // Main Screens
// import 'loading_screen.dart';
// import 'screens/main/search_screen.dart';
// import 'screens/main/doctor_detail_screen.dart';
// import 'screens/main/history_screen.dart';
// import 'screens/main/chat_screen.dart';
// import 'screens/main/notifikasi.dart';
// import 'screens/main/history_booking.dart';
// import 'screens/main/profil_pasien.dart';

// // Auth Screens
// import 'screens/auth/login.dart';
// import 'screens/auth/register.dart';

// // Admin Screens
// import 'screens/admin/kekuatan_admin.dart';
// import 'screens/admin/profil_admin.dart';
// import 'screens/admin/edit_admin.dart';
// import 'screens/admin/dokter/create_dokter.dart';
// import 'screens/admin/dokter/read_dokter.dart';
// import 'screens/admin/dokter/ud_dokter.dart';
// import 'screens/admin/pasien/read_pasien.dart';
// import 'screens/admin/pasien/ud_pasien.dart';
// import 'screens/admin/history_admin.dart';
// import 'screens/admin/persetujuan.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// /// Setup GoRouter
// final GoRouter _router = GoRouter(
//   initialLocation: '/loading',
//   routes: [
//     GoRoute(path: '/loading', builder: (context, state) => LoadingScreen()),
//     GoRoute(path: '/', builder: (context, state) => SearchScreen()),
//     GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
//     GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
//     GoRoute(path: '/detail', builder: (context, state) => DoctorDetailScreen()),
//     GoRoute(path: '/history', builder: (context, state) => HistoryScreen()),
//     GoRoute(
//         path: '/notifikasi', builder: (context, state) => NotifikasiScreen()),
//     GoRoute(
//         path: '/history-booking',
//         builder: (context, state) => HistoryBookingScreen()),
//     GoRoute(path: '/chat', builder: (context, state) => ChatScreen()),
//     GoRoute(
//         path: '/profil_pasien', builder: (context, state) => ProfilPasien()),

//     // Admin
//     GoRoute(
//         path: '/kekuatan_admin', builder: (context, state) => kekuatan_admin()),
//     GoRoute(path: '/profil-admin', builder: (context, state) => ProfilAdmin()),
//     GoRoute(path: '/edit-admin', builder: (context, state) => EditAdmin()),
//     GoRoute(
//         path: '/create_dokter', builder: (context, state) => CreateDokter()),
//     GoRoute(path: '/read_dokter', builder: (context, state) => ReadDokter()),
//     GoRoute(
//         path: '/updatedelete_dokter', builder: (context, state) => UdDokter()),
//     GoRoute(path: '/read_pasien', builder: (context, state) => ReadPasien()),
//     GoRoute(
//         path: '/updatedelete_pasien', builder: (context, state) => UdPasien()),
//     GoRoute(path: '/persetujuan', builder: (context, state) => Persetujuan()),
//     GoRoute(
//         path: '/history_admin', builder: (context, state) => HistoryAdmin()),
//   ],
// );

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => BookingProvider()),
//         ChangeNotifierProvider(create: (_) => SearchProvider()),
//         ChangeNotifierProvider(create: (_) => ChatProvider()),
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => ProfileProvider()),
//         ChangeNotifierProvider(create: (context) => DokterProvider(context)),
//       ],
//       child: MaterialApp.router(
//         debugShowCheckedModeBanner: false,
//         title: 'Aplikasi Booking Dokter',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         routerConfig: _router,
//       ),
//     );
//   }
// }
