import 'dart:async';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  final List<String> categories = ['Umum', 'Gigi', 'Anak', 'Kulit', 'Saraf'];
  String selectedCategory = 'Umum';

  final PageController pageController = PageController(viewportFraction: 0.9);
  final int totalPages = 2; // disesuaikan dengan 2 gambar promo
  int currentPage = 0;
  Timer? carouselTimer;

  SearchProvider() {
    startAutoScroll();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void startAutoScroll() {
    carouselTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (pageController.hasClients) {
        currentPage++;
        if (currentPage >= totalPages) currentPage = 0;
        pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    carouselTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
