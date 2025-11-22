import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/obat.dart';
import '../model/transaksi.dart';
import '../service/service_penyimpanan.dart';

class HalamanFormulirPembelian extends StatefulWidget {
  final Obat? obat;

  const HalamanFormulirPembelian({super.key, this.obat});

  @override
  State<HalamanFormulirPembelian> createState() =>
      _HalamanFormulirPembelianState();
}

class _HalamanFormulirPembelianState extends State<HalamanFormulirPembelian> {
  final _formKey = GlobalKey<FormState>();
  final _namaPembeliController = TextEditingController();
  final _jumlahPembelianController = TextEditingController();
  final _catatanController = TextEditingController();
  final _nomorResepController = TextEditingController();
  final _servicePenyimpanan = ServicePenyimpanan();

  Obat? _obatDipilih;
  String _metodePembelian = 'Pembelian Langsung';
  bool _sedangMemproses = false;

  @override
  void initState() {
    super.initState();
    _obatDipilih = widget.obat;
    _muatDataPengguna();
  }

  Future<void> _muatDataPengguna() async {
    final pengguna = await _servicePenyimpanan.dapatkanPenggunaAktif();
    if (pengguna != null && mounted) {
      setState(() {
        _namaPembeliController.text = pengguna.namaLengkap;
      });
    }
  }

  @override
  void dispose() {
    _namaPembeliController.dispose();
    _jumlahPembelianController.dispose();
    _catatanController.dispose();
    _nomorResepController.dispose();
    super.dispose();
  }

  String? _validasiNamaPembeli(String? nilai) {
    if (nilai == null || nilai.isEmpty) {
      return 'Nama pembeli wajib diisi';
    }
    return null;
  }

  String? _validasiJumlahPembelian(String? nilai) {
    if (nilai == null || nilai.isEmpty) {
      return 'Jumlah pembelian wajib diisi';
    }
    final jumlah = int.tryParse(nilai);
    if (jumlah == null || jumlah <= 0) {
      return 'Jumlah pembelian harus angka positif';
    }
    return null;
  }

  String? _validasiNomorResep(String? nilai) {
    if (_metodePembelian == 'Pembelian dengan Resep Dokter') {
      if (nilai == null || nilai.isEmpty) {
        return 'Nomor resep wajib diisi';
      }
      if (nilai.length < 6) {
        return 'Nomor resep minimal 6 karakter';
      }
      if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(nilai)) {
        return 'Nomor resep harus kombinasi huruf dan angka';
      }
    }
    return null;
  }

  Future<void> _simpanPembelian() async {
    if (_obatDipilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Silakan pilih obat terlebih dahulu',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _sedangMemproses = true;
      });

      final jumlah = int.parse(_jumlahPembelianController.text);
      final totalHarga = _obatDipilih!.harga * jumlah;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final transaksi = Transaksi(
        id: 'TRX$timestamp',
        idObat: _obatDipilih!.id,
        namaObat: _obatDipilih!.namaObat,
        kategoriObat: _obatDipilih!.kategori,
        gambarObat: _obatDipilih!.gambar,
        hargaSatuan: _obatDipilih!.harga,
        namaPembeli: _namaPembeliController.text.trim(),
        jumlahPembelian: jumlah,
        totalHarga: totalHarga,
        catatan: _catatanController.text.trim(),
        metodePembelian: _metodePembelian,
        nomorResep: _metodePembelian == 'Pembelian dengan Resep Dokter'
            ? _nomorResepController.text.trim()
            : null,
        tanggalPembelian: DateTime.now(),
        status: 'selesai',
      );

      final berhasil = await _servicePenyimpanan.simpanTransaksi(transaksi);

      setState(() {
        _sedangMemproses = false;
      });

      if (mounted) {
        if (berhasil) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.pink[500],
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pembelian Berhasil!',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Transaksi Anda telah tersimpan',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.pink[600],
                    ),
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[500],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Kembali',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal menyimpan transaksi',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Colors.red[400],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink[50]!, Colors.white, Colors.pink[100]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buatHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_obatDipilih == null) _buatPilihObat(),
                        if (_obatDipilih != null) _buatInfoObat(),
                        const SizedBox(height: 24),
                        _buatKolomInput(
                          controller: _namaPembeliController,
                          label: 'Nama Pembeli',
                          ikon: Icons.person_rounded,
                          validator: _validasiNamaPembeli,
                        ),
                        const SizedBox(height: 20),
                        _buatKolomInput(
                          controller: _jumlahPembelianController,
                          label: 'Jumlah Pembelian',
                          ikon: Icons.shopping_bag_rounded,
                          tipeKeyboard: TextInputType.number,
                          validator: _validasiJumlahPembelian,
                        ),
                        const SizedBox(height: 20),
                        _buatKolomInput(
                          controller: _catatanController,
                          label: 'Catatan (Opsional)',
                          ikon: Icons.note_rounded,
                          maksBaris: 3,
                        ),
                        const SizedBox(height: 24),
                        _buatPilihMetode(),
                        if (_metodePembelian == 'Pembelian dengan Resep Dokter')
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              _buatKolomInput(
                                controller: _nomorResepController,
                                label: 'Nomor Resep Dokter',
                                ikon: Icons.medical_services_rounded,
                                validator: _validasiNomorResep,
                              ),
                            ],
                          ),
                        const SizedBox(height: 30),
                        if (_obatDipilih != null &&
                            _jumlahPembelianController.text.isNotEmpty)
                          _buatRingkasan(),
                        const SizedBox(height: 30),
                        Container(
                          height: 58,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.pink[400]!, Colors.pink[600]!],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink[300]!.withOpacity(0.5),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _sedangMemproses
                                ? null
                                : _simpanPembelian,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _sedangMemproses
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'KONFIRMASI PEMBELIAN',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buatHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink[400]!, Colors.pink[600]!],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pink[300]!.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Formulir Pembelian',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Lengkapi data pembelian obat',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buatPilihObat() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink[200]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.pink[100]!.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Obat',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Obat>(
            value: _obatDipilih,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.medication_rounded,
                color: Colors.pink[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.pink[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.pink[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.pink[400]!, width: 2),
              ),
            ),
            hint: Text(
              'Pilih obat yang dibeli',
              style: GoogleFonts.poppins(color: Colors.grey[500]),
            ),
            items: Obat.daftarObat().map((obat) {
              return DropdownMenuItem<Obat>(
                value: obat,
                child: Text(
                  '${obat.gambar} ${obat.namaObat}',
                  style: GoogleFonts.poppins(
                    color: Colors.pink[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _obatDipilih = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buatInfoObat() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.pink[50]!, Colors.pink[100]!]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink[200]!.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _obatDipilih!.gambar,
              style: const TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _obatDipilih!.kategori,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _obatDipilih!.namaObat,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${NumberFormat('#,###', 'id_ID').format(_obatDipilih!.harga)}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[700],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.pink[600]),
            onPressed: () {
              setState(() {
                _obatDipilih = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buatPilihMetode() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink[100]!.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metode Pembelian',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
          const SizedBox(height: 16),
          _buatOpsiMetode('Pembelian Langsung', Icons.shopping_cart_rounded),
          const SizedBox(height: 12),
          _buatOpsiMetode(
            'Pembelian dengan Resep Dokter',
            Icons.assignment_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buatOpsiMetode(String metode, IconData ikon) {
    final dipilih = _metodePembelian == metode;
    return InkWell(
      onTap: () {
        setState(() {
          _metodePembelian = metode;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dipilih ? Colors.pink[50] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: dipilih ? Colors.pink[400]! : Colors.grey[300]!,
            width: dipilih ? 2.5 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: dipilih ? Colors.pink[400] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(ikon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                metode,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: dipilih ? FontWeight.bold : FontWeight.w500,
                  color: dipilih ? Colors.pink[800] : Colors.grey[700],
                ),
              ),
            ),
            if (dipilih)
              Icon(Icons.check_circle_rounded, color: Colors.pink[600]),
          ],
        ),
      ),
    );
  }

  Widget _buatRingkasan() {
    final jumlah = int.tryParse(_jumlahPembelianController.text) ?? 0;
    final total = _obatDipilih!.harga * jumlah;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink[600]!, Colors.pink[400]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink[400]!.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Pembelian',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buatBarisRingkasan(
            'Harga Satuan',
            'Rp ${NumberFormat('#,###', 'id_ID').format(_obatDipilih!.harga)}',
          ),
          const SizedBox(height: 8),
          _buatBarisRingkasan('Jumlah', '$jumlah item'),
          const Divider(color: Colors.white, thickness: 1.5, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Rp ${NumberFormat('#,###', 'id_ID').format(total)}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buatBarisRingkasan(String label, String nilai) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          nilai,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buatKolomInput({
    required TextEditingController controller,
    required String label,
    required IconData ikon,
    TextInputType? tipeKeyboard,
    int maksBaris = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink[100]!.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: tipeKeyboard,
        maxLines: maksBaris,
        style: GoogleFonts.poppins(fontSize: 15, color: Colors.pink[900]),
        onChanged: (value) {
          if (label == 'Jumlah Pembelian') {
            setState(() {});
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.pink[400],
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(ikon, color: Colors.pink[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.pink[100]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.pink[400]!, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
