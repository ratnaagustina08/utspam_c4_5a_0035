class Transaksi {
  final String id;
  final String idObat;
  final String namaObat;
  final String kategoriObat;
  final String gambarObat;
  final double hargaSatuan;
  final String namaPembeli;
  final int jumlahPembelian;
  final double totalHarga;
  final String catatan;
  final String metodePembelian;
  final String? nomorResep;
  final DateTime tanggalPembelian;
  final String status;

  Transaksi({
    required this.id,
    required this.idObat,
    required this.namaObat,
    required this.kategoriObat,
    required this.gambarObat,
    required this.hargaSatuan,
    required this.namaPembeli,
    required this.jumlahPembelian,
    required this.totalHarga,
    required this.catatan,
    required this.metodePembelian,
    this.nomorResep,
    required this.tanggalPembelian,
    required this.status,
  });

  Map<String, dynamic> keMap() {
    return {
      'id': id,
      'idObat': idObat,
      'namaObat': namaObat,
      'kategoriObat': kategoriObat,
      'gambarObat': gambarObat,
      'hargaSatuan': hargaSatuan,
      'namaPembeli': namaPembeli,
      'jumlahPembelian': jumlahPembelian,
      'totalHarga': totalHarga,
      'catatan': catatan,
      'metodePembelian': metodePembelian,
      'nomorResep': nomorResep,
      'tanggalPembelian': tanggalPembelian.toIso8601String(),
      'status': status,
    };
  }

  factory Transaksi.dariMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'] ?? '',
      idObat: map['idObat'] ?? '',
      namaObat: map['namaObat'] ?? '',
      kategoriObat: map['kategoriObat'] ?? '',
      gambarObat: map['gambarObat'] ?? '',
      hargaSatuan: (map['hargaSatuan'] ?? 0).toDouble(),
      namaPembeli: map['namaPembeli'] ?? '',
      jumlahPembelian: map['jumlahPembelian'] ?? 0,
      totalHarga: (map['totalHarga'] ?? 0).toDouble(),
      catatan: map['catatan'] ?? '',
      metodePembelian: map['metodePembelian'] ?? '',
      nomorResep: map['nomorResep'],
      tanggalPembelian: DateTime.parse(map['tanggalPembelian']),
      status: map['status'] ?? 'selesai',
    );
  }

  Transaksi salinDengan({
    String? id,
    String? idObat,
    String? namaObat,
    String? kategoriObat,
    String? gambarObat,
    double? hargaSatuan,
    String? namaPembeli,
    int? jumlahPembelian,
    double? totalHarga,
    String? catatan,
    String? metodePembelian,
    String? nomorResep,
    DateTime? tanggalPembelian,
    String? status,
  }) {
    return Transaksi(
      id: id ?? this.id,
      idObat: idObat ?? this.idObat,
      namaObat: namaObat ?? this.namaObat,
      kategoriObat: kategoriObat ?? this.kategoriObat,
      gambarObat: gambarObat ?? this.gambarObat,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      namaPembeli: namaPembeli ?? this.namaPembeli,
      jumlahPembelian: jumlahPembelian ?? this.jumlahPembelian,
      totalHarga: totalHarga ?? this.totalHarga,
      catatan: catatan ?? this.catatan,
      metodePembelian: metodePembelian ?? this.metodePembelian,
      nomorResep: nomorResep ?? this.nomorResep,
      tanggalPembelian: tanggalPembelian ?? this.tanggalPembelian,
      status: status ?? this.status,
    );
  }
}
