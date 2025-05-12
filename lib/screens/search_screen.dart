import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/doctor_card.dart';
import '../providers/search_provider.dart'; // Sesuaikan path

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Cari Dokter', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.history, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/history');
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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

                // Chips
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.categories.length,
                    itemBuilder: (context, index) {
                      final category = provider.categories[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: provider.selectedCategory == category,
                          selectedColor: Colors.black,
                          onSelected: (_) => provider.selectCategory(category),
                          labelStyle: TextStyle(
                            color: provider.selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 24),

                // Carousel
                SizedBox(
                  height: 160,
                  child: PageView.builder(
                    controller: provider.pageController,
                    itemCount: provider.totalPages,
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

                Text(
                  "Dokter Tersedia",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return DoctorCard(
                      name: "dr. Contoh $index",
                      specialty: "Spesialis ${provider.selectedCategory}",
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/detail'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
