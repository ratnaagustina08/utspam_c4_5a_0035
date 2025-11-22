class Obat {
  final String id;
  final String namaObat;
  final String kategori;
  final double harga;
  final String gambar;
  final String deskripsi;

  Obat({
    required this.id,
    required this.namaObat,
    required this.kategori,
    required this.harga,
    required this.gambar,
    required this.deskripsi,
  });

  static List<Obat> daftarObat() {
    return [
      Obat(
        id: 'OBT001',
        namaObat: 'Paracetamol 500mg',
        kategori: 'Analgesik',
        harga: 15000,
        gambar: '💊',
        deskripsi: 'Obat pereda nyeri dan penurun demam',
      ),
      Obat(
        id: 'OBT002',
        namaObat: 'Amoxicillin 500mg',
        kategori: 'Antibiotik',
        harga: 45000,
        gambar: '💉',
        deskripsi: 'Antibiotik untuk infeksi bakteri',
      ),
      Obat(
        id: 'OBT003',
        namaObat: 'Vitamin C 1000mg',
        kategori: 'Vitamin',
        harga: 25000,
        gambar: '🍊',
        deskripsi: 'Suplemen vitamin C untuk daya tahan tubuh',
      ),
      Obat(
        id: 'OBT004',
        namaObat: 'Betadine Solution',
        kategori: 'Antiseptik',
        harga: 35000,
        gambar: '🧴',
        deskripsi: 'Antiseptik untuk luka luar',
      ),
      Obat(
        id: 'OBT005',
        namaObat: 'OBH Combi',
        kategori: 'Obat Batuk',
        harga: 28000,
        gambar: '🍯',
        deskripsi: 'Obat batuk berdahak',
      ),
      Obat(
        id: 'OBT006',
        namaObat: 'Promag Tablet',
        kategori: 'Antasida',
        harga: 12000,
        gambar: '⚕️',
        deskripsi: 'Obat maag dan gangguan lambung',
      ),
      Obat(
        id: 'OBT007',
        namaObat: 'Sangobion',
        kategori: 'Suplemen',
        harga: 38000,
        gambar: '💪',
        deskripsi: 'Suplemen penambah darah',
      ),
      Obat(
        id: 'OBT008',
        namaObat: 'Neuralgin RX',
        kategori: 'Analgesik',
        harga: 18000,
        gambar: '🩺',
        deskripsi: 'Obat sakit kepala dan nyeri otot',
      ),
      Obat(
        id: 'OBT009',
        namaObat: 'Imboost Force',
        kategori: 'Vitamin',
        harga: 55000,
        gambar: '🛡️',
        deskripsi: 'Suplemen daya tahan tubuh',
      ),
      Obat(
        id: 'OBT010',
        namaObat: 'Salep 88',
        kategori: 'Antiseptik',
        harga: 22000,
        gambar: '🧪',
        deskripsi: 'Salep untuk gatal dan iritasi kulit',
      ),
    ];
  }

  Map<String, dynamic> keMap() {
    return {
      'id': id,
      'namaObat': namaObat,
      'kategori': kategori,
      'harga': harga,
      'gambar': gambar,
      'deskripsi': deskripsi,
    };
  }

  factory Obat.dariMap(Map<String, dynamic> map) {
    return Obat(
      id: map['id'] ?? '',
      namaObat: map['namaObat'] ?? '',
      kategori: map['kategori'] ?? '',
      harga: (map['harga'] ?? 0).toDouble(),
      gambar: map['gambar'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
    );
  }
}
