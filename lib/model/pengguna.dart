class Pengguna {
  final String namaLengkap;
  final String email;
  final String nomorTelepon;
  final String alamat;
  final String username;
  final String password;

  Pengguna({
    required this.namaLengkap,
    required this.email,
    required this.nomorTelepon,
    required this.alamat,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> keMap() {
    return {
      'namaLengkap': namaLengkap,
      'email': email,
      'nomorTelepon': nomorTelepon,
      'alamat': alamat,
      'username': username,
      'password': password,
    };
  }

  factory Pengguna.dariMap(Map<String, dynamic> map) {
    return Pengguna(
      namaLengkap: map['namaLengkap'] ?? '',
      email: map['email'] ?? '',
      nomorTelepon: map['nomorTelepon'] ?? '',
      alamat: map['alamat'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
