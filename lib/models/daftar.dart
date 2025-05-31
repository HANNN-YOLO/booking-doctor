class Daftar {
  String? kunci;
  int? id;
  String? nama;
  String? email;
  String? password;
  DateTime? tgllahir;
  String? asal;
  String? alamat;

  Daftar(
      {this.kunci,
      this.id,
      this.nama,
      this.email,
      this.password,
      this.tgllahir,
      this.asal,
      this.alamat});

  Map<String, dynamic> models_ke_firebase() {
    return {
      'kunci': kunci,
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'tgllahir': tgllahir?.toIso8601String(),
      'asal': asal,
      'alamat': alamat
    };
  }
}
