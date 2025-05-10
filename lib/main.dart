import 'package:booking_doctor/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'screens/search_screen.dart';
import 'screens/doctor_detail_screen.dart';
import 'screens/chat_screen.dart';
// import 'screens/booking_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen(),
      routes: {
        SearchScreen.routing: (context) => SearchScreen(),
        DoctorDetailScreen.routing: (context) => DoctorDetailScreen(),
        ChatScreen.routing: (context) => ChatScreen(),
        HistoryScreen.routing: (context) => HistoryScreen(),
        // BookingScreen.routing: (context) => BookingScreen(),
      },
    );
  }
}
