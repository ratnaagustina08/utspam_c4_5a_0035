import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/transaksi.dart';
import '../service/service_penyimpanan.dart';
import '../widget/gambar_obat.dart';
import 'halaman_detail_pembelian.dart';

class HalamanRiwayatPembelian extends StatefulWidget {
  const HalamanRiwayatPembelian({super.key});

  @override
  State<HalamanRiwayatPembelian> createState() =>
      _HalamanRiwayatPembelianState();
}

class _HalamanRiwayatPembelianState extends State<HalamanRiwayatPembelian> {
  final _servicePenyimpanan = ServicePenyimpanan();
  List<Transaksi> _daftarTransaksi = [];
  bool _sedangMemuat = true;

  @override
  void initState() {
    super.initState();
    _muatTransaksi();
  }

  Future<void> _muatTransaksi() async {
    setState(() {
      _sedangMemuat = true;
    });

    final transaksi = await _servicePenyimpanan.dapatkanSemuaTransaksi();

    setState(() {
      _daftarTransaksi = transaksi.reversed.toList();
      _sedangMemuat = false;
    });
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
                child: _sedangMemuat
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.pink[500],
                          strokeWidth: 3,
                        ),
                      )
                    : _daftarTransaksi.isEmpty
                    ? _buatTampilanKosong()
                    : _buatDaftarTransaksi(),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Pembelian',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_daftarTransaksi.length} transaksi',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              onPressed: _muatTransaksi,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatTampilanKosong() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: Colors.pink[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Transaksi',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Riwayat pembelian Anda akan muncul di sini',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.pink[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatDaftarTransaksi() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _daftarTransaksi.length,
      itemBuilder: (context, index) {
        return _buatKartuTransaksi(_daftarTransaksi[index]);
      },
    );
  }

  Widget _buatKartuTransaksi(Transaksi transaksi) {
    final formatter = NumberFormat('#,###', 'id_ID');
    final formatTanggal = DateFormat('dd MMM yyyy, HH:mm');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HalamanDetailPembelian(transaksi: transaksi),
            ),
          );
          _muatTransaksi();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.pink[100]!.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: transaksi.status == 'selesai'
                        ? [Colors.pink[50]!, Colors.pink[100]!]
                        : [Colors.grey[200]!, Colors.grey[300]!],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: GambarObat(
                        urlGambar: transaksi.gambarObat,
                        lebar: 60,
                        tinggi: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaksi.namaObat,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[900],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: transaksi.status == 'selesai'
                                  ? Colors.pink[300]
                                  : Colors.grey[500],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              transaksi.kategoriObat,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: transaksi.status == 'selesai'
                            ? Colors.green[500]
                            : Colors.red[500],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        transaksi.status == 'selesai'
                            ? 'Selesai'
                            : 'Dibatalkan',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buatBarisInfo(
                      ikon: Icons.person_rounded,
                      label: 'Pembeli',
                      nilai: transaksi.namaPembeli,
                    ),
                    const SizedBox(height: 10),
                    _buatBarisInfo(
                      ikon: Icons.shopping_bag_rounded,
                      label: 'Jumlah',
                      nilai: '${transaksi.jumlahPembelian} item',
                    ),
                    const SizedBox(height: 10),
                    _buatBarisInfo(
                      ikon: Icons.calendar_today_rounded,
                      label: 'Tanggal',
                      nilai: formatTanggal.format(transaksi.tanggalPembelian),
                    ),
                    const Divider(height: 24, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink[700],
                          ),
                        ),
                        Text(
                          'Rp ${formatter.format(transaksi.totalHarga)}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buatBarisInfo({
    required IconData ikon,
    required String label,
    required String nilai,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.pink[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(ikon, size: 18, color: Colors.pink[500]),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
            ),
            Text(
              nilai,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.pink[900],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
