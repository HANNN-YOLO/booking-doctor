class Doctor {
  final int id_doctor;
  final String name;
  final String specialty;
  final String experience;
  final String hospital;
  final String education;
  final String availableDay;
  final String availableTime;
  final String imageUrl;

  Doctor({
    required this.id_doctor,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.hospital,
    required this.education,
    required this.availableDay,
    required this.availableTime,
    required this.imageUrl,
  });

  factory Doctor.fromMap(Map<String, dynamic> data, String documentId) {
    return Doctor(
      id_doctor: data['id_doctor'] ?? 0, 
      name: data['name'] ?? '',
      specialty: data['specialty'] ?? '',
      experience: data['experience'] ?? '',
      hospital: data['hospital'] ?? '',
      education: data['education'] ?? '',
      availableDay: data['availableDay'] ?? '',
      availableTime: data['availableTime'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'experience': experience,
      'hospital': hospital,
      'education': education,
      'availableDay': availableDay,
      'availableTime': availableTime,
      'imageUrl': imageUrl,
    };
  }
}
