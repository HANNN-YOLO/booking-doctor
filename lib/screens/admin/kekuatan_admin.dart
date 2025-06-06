import 'package:flutter/material.dart';

class kekuatan_admin extends StatelessWidget {
  static const arah = 'kekuatan_admin';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "Kekuatan Admin",
          style: TextStyle(color: Colors.white),
        ),
        leading: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  image: AssetImage('assets/logo-removebg-preview.png'),
                  fit: BoxFit.cover)),
        ),
        actions: [
          Builder(
              builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  )))
        ],
      ),
      drawer: Drawer(
        width: 200,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 35),
              child:
                  ListTile(title: Text("Profil Saya"), leading: CircleAvatar()),
            ),
            Container(
              height: 650,
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Pasien"),
                    leading: CircleAvatar(),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     image: DecorationImage(
                    //       image: image,
                    //       fit: BoxFit.cover
                    //       )
                    //   ),
                    // ),
                  ),
                  ListTile(
                    title: Text("Dokter"),
                    leading: CircleAvatar(),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/updatedelete_dokter'),
                  ),
                  ListTile(
                    title: Text("Persetujuan"),
                    leading: CircleAvatar(),
                  ),
                  ListTile(
                    title: Text("History"),
                    leading: CircleAvatar(),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 35),
              child: ListTile(
                  title: Text("Log Out"),
                  leading: CircleAvatar(),
                  onTap: () {
                    Navigator.of(context).pushNamed('/login');
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
