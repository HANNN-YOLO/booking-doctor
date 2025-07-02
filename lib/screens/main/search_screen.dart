import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/doctor_card.dart';
import '../../providers/dokter_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context);
    final isi = Provider.of<DokterProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF96D165),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TemuDok',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/notifikasi');
                            },
                            icon: Icon(Icons.notifications_none,
                                color: Colors.black),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/history-booking');
                            },
                            icon: Icon(Icons.history, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              isi.setSearchQuery(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chips
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Spesialis',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: isi.dumydata.length,
                            itemBuilder: (context, index) {
                              final category = isi.dumydata[index].specialty;
                              final isSelected =
                                  isi.pilihanSpesialis == category;

                              // Skip if specialty is already shown
                              if (index > 0 &&
                                  isi.dumydata
                                      .take(index)
                                      .any((d) => d.specialty == category)) {
                                return Container();
                              }

                              return Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(category),
                                  selected: isSelected,
                                  selectedColor: Colors.green[600],
                                  onSelected: (bool selected) {
                                    isi.read_spesialis(category, context);
                                  },
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  backgroundColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    // Promo Menarik Carousel
                    SizedBox(height: 24),
                    Text(
                      'Promo Menarik',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: provider.pageController,
                        itemCount: provider.totalPages,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: AssetImage('assets/banner_$index.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Dokter Tersedia
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dokter Tersedia',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (isi.pilihanSpesialis != 'Semua')
                          TextButton(
                            onPressed: () {
                              isi.read_spesialis(isi.pilihanSpesialis, context);
                            },
                            child: Text(
                              'Reset Filter',
                              style: TextStyle(
                                color: Colors.green[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: isi.dumydata.length,
                      itemBuilder: (context, index) {
                        final doctor = isi.dumydata[index];
                        return DoctorCard(
                          gambar: doctor.imageUrl,
                          name: doctor.name,
                          specialty: 'Spesialis ${doctor.specialty}',
                          onTap: () => Navigator.pushReplacementNamed(
                              context, '/detail',
                              arguments: isi.dumydata[index].kunci),
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

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blue[700],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/dashboard');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/profil_pasien');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
