import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/booking_provider.dart';
import 'providers/search_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/search_screen.dart';
import 'screens/doctor_detail_screen.dart';
import 'screens/history_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/profile_provider.dart';
import 'screens/kekuatan_admin.dart';
import '/screens/create_dokter.dart';
import '/screens/history_admin.dart';
import '/screens/persetujuan.dart';
import '/screens/read_dokter.dart';
import '/screens/read_pasien.dart';
import '/screens/ud_dokter.dart';
import '/screens/ud_pasien.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Booking Dokter',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/': (context) => SearchScreen(),
          '/detail': (context) => DoctorDetailScreen(),
          '/history': (context) => HistoryScreen(),
          '/chat': (context) => ChatScreen(),
          '/kekuatan_admin': (context) => kekuatan_admin(),
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
