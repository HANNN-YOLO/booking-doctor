import 'package:booking_doctor/models/doctor.dart';
import 'package:booking_doctor/providers/dokter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UdDokter extends StatelessWidget {
  static const arah = 'updatedelete_dokter';

  final TextEditingController name = TextEditingController();
  final TextEditingController spesialis = TextEditingController();
  final TextEditingController brplama = TextEditingController();
  final TextEditingController hospital = TextEditingController();
  final TextEditingController belajar = TextEditingController();
  final TextEditingController imageurl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DokterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF96D165),
        title: Text(
          "List Dokter",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/create_dokter');
            },
            icon: Icon(Icons.add),
            color: Colors.white,
          ),
          // IconButton(
          //   onPressed: () {
          //     data.read(context);
          //   },
          //   icon: Icon(Icons.book),
          //   color: Colors.white,
          // )
        ],
      ),
      body: (data.dumydata.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Datanya masih kosong",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/inputan');
                    },
                    child: Text(
                      "Buat Data",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              child: Consumer<DokterProvider>(
                builder: (context, value, child) => ListView.builder(
                  itemCount: value.dumydata.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(data.dumydata[index].name),
                    onTap: () => Navigator.of(context).pushNamed(
                      '/detail',
                      arguments: value.dumydata[index].kunci,
                    ),
                    leading: CircleAvatar(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              data.dumydata[index].imageUrl,
                            ),
                          ),
                        ),
                      ),
                    ),
                    subtitle: Text(data.dumydata[index].specialty),
                    trailing: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              data.delete(context, value.dumydata[index].kunci);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              name.text = "${data.dumydata[index].name}";
                              spesialis.text =
                                  "${data.dumydata[index].specialty}";
                              brplama.text =
                                  "${data.dumydata[index].experience}";
                              hospital.text =
                                  "${data.dumydata[index].hospital}";
                              belajar.text = "${data.dumydata[index].hospital}";
                              imageurl.text =
                                  "${data.dumydata[index].imageUrl}";
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Container(
                                    height: 500,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Perubahan"),
                                        TextField(
                                          keyboardType: TextInputType.name,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          controller: name,
                                          decoration: InputDecoration(
                                            hintText: "Perubahan Nama",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          keyboardType: TextInputType.name,
                                          controller: spesialis,
                                          decoration: InputDecoration(
                                            hintText: "Perunahan Spesialis",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          keyboardType: TextInputType.name,
                                          controller: brplama,
                                          decoration: InputDecoration(
                                            hintText: "Perunahan berapa lama",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          keyboardType: TextInputType.name,
                                          controller: hospital,
                                          decoration: InputDecoration(
                                            hintText: "Perunahan Rumah Sakit",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          keyboardType: TextInputType.name,
                                          controller: belajar,
                                          decoration: InputDecoration(
                                            hintText: "Perunahan Studi Akhir",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          controller: imageurl,
                                          textInputAction: TextInputAction.done,
                                          onEditingComplete: () {},
                                          decoration: InputDecoration(
                                            hintText: "Perubahan Gambar",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                  ).pop();
                                                },
                                                child: Text(
                                                  "Back",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.cyan,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  data.update(
                                                      context,
                                                      data.dumydata[index]
                                                          .kunci,
                                                      name.text,
                                                      spesialis.text,
                                                      int.parse(brplama.text),
                                                      hospital.text,
                                                      belajar.text,
                                                      imageurl.text);
                                                },
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.update,
                              color: Colors.cyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
