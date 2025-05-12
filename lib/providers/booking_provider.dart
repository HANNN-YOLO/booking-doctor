import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  DateTime? selectDateTime;

  void setDateTime(DateTime datetime) {
    selectDateTime = datetime;
    notifyListeners();
  }
}
