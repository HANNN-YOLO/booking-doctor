class Daftar {
  String? kunci;
  final String? id;
  final String? nama;
  final String? email;
  final String? password;
  final String? role;
  final int? nohp;
  final DateTime? tgllahir;
  final String? asal;
  final String? alamat;
  final String? gambar;

  Daftar(
      {this.kunci,
      this.id,
      this.nama,
      this.email,
      this.password,
      this.role,
      this.nohp,
      this.tgllahir,
      this.asal,
      this.alamat,
      this.gambar});

  factory Daftar.fromJson(String kunci, Map<String, dynamic> json) {
    return Daftar(
      kunci: kunci,
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      nohp: json['nohp'] != null ? int.parse(json['nohp'].toString()) : null,
      tgllahir:
          json['tgllahir'] != null ? DateTime.tryParse(json['tgllahir']) : null,
      asal: json['asal'],
      alamat: json['alamat'],
      gambar: json['gambar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'password': password,
      'role': role,
      'nohp': nohp,
      'tgllahir': tgllahir?.toIso8601String(),
      'asal': asal,
      'alamat': alamat,
      'gambar': gambar
    };
  }

  Daftar copyWith(
      {String? id,
      String? nama,
      String? email,
      String? password,
      String? role,
      int? nohp,
      DateTime? tgllahir,
      String? asal,
      String? alamat,
      String? gambar}) {
    return Daftar(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role,
        nohp: nohp ?? this.nohp,
        tgllahir: tgllahir ?? this.tgllahir,
        asal: asal ?? this.asal,
        alamat: alamat ?? this.alamat,
        gambar: gambar ?? this.gambar);
  }

  Map<String, dynamic> models_ke_firebase() {
    return {
      'kunci': kunci,
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'role': role,
      'tgllahir': tgllahir?.toIso8601String(),
      'asal': asal,
      'alamat': alamat,
      'gambar': gambar
    };
  }
}
