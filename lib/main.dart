import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/booking_provider.dart';
import 'screens/search_screen.dart';
import 'screens/doctor_detail_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/history_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Booking Dokter',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => SearchScreen(),
          '/detail': (context) => DoctorDetailScreen(),
          '/booking': (context) => BookingScreen(),
          '/history': (context) => HistoryScreen(),
          '/chat': (context) => ChatScreen(),
        },
      ),
    );
  }
}
