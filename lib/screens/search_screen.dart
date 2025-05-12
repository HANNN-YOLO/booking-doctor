import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/doctor_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> categories = ['Umum', 'Gigi', 'Anak', 'Kulit', 'Saraf'];
  String selectedCategory = 'Umum';

  final PageController _pageController = PageController(viewportFraction: 0.9);
  final int _totalPages = 3;
  int _currentPage = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _carouselTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= _totalPages) _currentPage = 0;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sticky Header (ikon menu + notif)
            SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderDelegate(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.menu, size: 28),
                      Row(
                        children: [
                          Icon(Icons.notifications_none),
                          SizedBox(width: 12),
                          CircleAvatar(radius: 16, backgroundColor: Colors.grey[300]),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            // Konten Utama
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Cari Dokter',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.search, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Chip Kategori
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: selectedCategory == category,
                              selectedColor: Colors.black,
                              onSelected: (selected) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              labelStyle: TextStyle(
                                color: selectedCategory == category ? Colors.white : Colors.black,
                              ),
                              backgroundColor: Colors.grey[200],
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 24),

                    // Carousel Gambar
                    SizedBox(
                      height: 160,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _totalPages,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey[300],
                              image: DecorationImage(
                                image: AssetImage('assets/banner_$index.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 24),

                    // Judul List Dokter
                    Text(
                      "Dokter Tersedia",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),

                    SizedBox(height: 12),

                    // List Dokter
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return DoctorCard(
                          name: "dr. Contoh $index",
                          specialty: "Spesialis $selectedCategory",
                          onTap: () {
                            Navigator.pushNamed(context, '/detail');
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sticky Header Delegate Class
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _HeaderDelegate({required this.child});

  @override
  double get minExtent => 64;
  @override
  double get maxExtent => 64;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
