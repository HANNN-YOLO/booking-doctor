import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:intl/intl.dart';
import '../../models/daftar.dart';

class EditProfilPasien extends StatelessWidget {
  static const arah = 'edit_profil_pasien';
  EditProfilPasien({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _nohpController = TextEditingController();
  final _tglLahirController = TextEditingController();
  final _asalController = TextEditingController();
  final _alamatController = TextEditingController();

  void _initializeControllers(BuildContext context) {
    final profileData =
        Provider.of<ProfileProvider>(context, listen: false).profileData;
    if (profileData != null) {
      _namaController.text = profileData['nama'] ?? '';
      _nohpController.text = profileData['nohp']?.toString() ?? '';
      _tglLahirController.text = profileData['tgllahir'] != null
          ? DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(profileData['tgllahir']))
          : '';
      _asalController.text = profileData['asal'] ?? '';
      _alamatController.text = profileData['alamat'] ?? '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final profileData =
        Provider.of<ProfileProvider>(context, listen: false).profileData;
    final currentDate = profileData?['tgllahir'] != null
        ? DateTime.parse(profileData!['tgllahir'])
        : DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _tglLahirController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeControllers(context);

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          height: 580,
          width: 400,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'URL Gambar',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nohpController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor telepon tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _tglLahirController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Lahir',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal lahir tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _asalController,
                    decoration: const InputDecoration(
                      labelText: 'Asal',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Asal tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _alamatController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final updatedData = {
                              'nama': _namaController.text,
                              'nohp': int.tryParse(_nohpController.text),
                              'tgllahir': DateFormat('dd/MM/yyyy')
                                  .parse(_tglLahirController.text)
                                  .toIso8601String(),
                              'asal': _asalController.text,
                              'alamat': _alamatController.text,
                              'gambar': _imageUrlController
                            };

                            // Get current user ID from Auth Provider
                            final userId = Provider.of<AuthProvider>(context,
                                    listen: false)
                                .user
                                ?.uid;
                            if (userId != null) {
                              final success =
                                  await profileProvider.updateProfile(
                                userId,
                                updatedData,
                                context,
                              );

                              if (success && context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF96D165),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Simpan Perubahan',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
