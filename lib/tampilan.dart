import 'package:flutter/material.dart';

class TampilanScreen extends StatelessWidget {
  final List<String> carouselImages = [
    'https://via.placeholder.com/400x180.png?text=Promo+1',
    'https://via.placeholder.com/400x180.png?text=Promo+2',
    'https://via.placeholder.com/400x180.png?text=Promo+3',
  ];

  final List<Map<String, dynamic>> menuItems = [
    {'label': 'Chat dengan Dokter', 'icon': Icons.chat},
    {'label': 'Toko Kesehatan', 'icon': Icons.shopping_bag},
    {'label': 'Homecare', 'icon': Icons.home},
    {'label': 'Asuransiku', 'icon': Icons.health_and_safety},
    {'label': 'Halofit', 'icon': Icons.fitness_center},
    {'label': 'Haloskin', 'icon': Icons.spa},
    {'label': 'Kesehatan Seksual', 'icon': Icons.favorite},
    {'label': 'Lihat Semua', 'icon': Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Beranda")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Masuk/Daftar
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(child: Icon(Icons.person)),
                  SizedBox(width: 8),
                  Text("Masuk/Daftar", style: TextStyle(fontSize: 16, color: Colors.pink)),
                ],
              ),
            ),

            // Menu Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: menuItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.pink.shade50,
                        child: Icon(item['icon'], color: Colors.pink),
                      ),
                      SizedBox(height: 4),
                      Text(item['label'], textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // Carousel Slider
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                itemCount: carouselImages.length,
                itemBuilder: (context, index) {
                  return _buildCarouselItem(carouselImages[index]);
                },
              ),
            ),

            SizedBox(height: 20),

            // Artikel Baris Atas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Baca 100+ Artikel Baru", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Lihat Semua", style: TextStyle(color: Colors.pink)),
                ],
              ),
            ),

            // Kategori Chip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text("Semua"), backgroundColor: Colors.pink.shade100),
                  Chip(label: Text("Hernia Diafragmatika")),
                  Chip(label: Text("Kista Baker")),
                ],
              ),
            ),

            // Artikel Gambar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildArticleCard(
                    image: 'https://via.placeholder.com/400x200.png?text=Artikel+1',
                    title: 'Lulur Pemutih Badan, Permanenkah Hasilnya?',
                  ),
                  SizedBox(height: 16),
                  _buildArticleCard(
                    image: 'https://via.placeholder.com/400x200.png?text=Artikel+2',
                    title: 'Tips Menghindari Nyamuk Saat Tidur',
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),

      // Bottom Navigation Dummy
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Pesan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String imageUrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildArticleCard({required String image, required String title}) {
    return Card(
      child: Column(
        children: [
          Image.network(image, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
