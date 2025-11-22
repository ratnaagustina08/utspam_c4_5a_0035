import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/transaksi.dart';
import '../service/service_penyimpanan.dart';
import '../widget/gambar_obat.dart';
import 'halaman_edit_transaksi.dart';

class HalamanDetailPembelian extends StatefulWidget {
  final Transaksi transaksi;

  const HalamanDetailPembelian({super.key, required this.transaksi});

  @override
  State<HalamanDetailPembelian> createState() => _HalamanDetailPembelianState();
}

class _HalamanDetailPembelianState extends State<HalamanDetailPembelian> {
  final _servicePenyimpanan = ServicePenyimpanan();
  late Transaksi _transaksi;

  @override
  void initState() {
    super.initState();
    _transaksi = widget.transaksi;
  }

  Future<void> _konfirmasiBatalkan() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Batalkan Transaksi?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.pink[800],
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin membatalkan transaksi ini? Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.poppins(color: Colors.pink[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Tidak',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Ya, Batalkan',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (konfirmasi == true && mounted) {
      final transaksiDiperbarui = _transaksi.salinDengan(status: 'dibatalkan');
      final berhasil = await _servicePenyimpanan.perbaruiTransaksi(
        transaksiDiperbarui,
      );

      if (mounted) {
        if (berhasil) {
          setState(() {
            _transaksi = transaksiDiperbarui;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Transaksi berhasil dibatalkan',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Colors.green[500],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal membatalkan transaksi',
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
    final formatter = NumberFormat('#,###', 'id_ID');
    final formatTanggal = DateFormat('dd MMMM yyyy, HH:mm');

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buatKartuObat(),
                      const SizedBox(height: 20),
                      _buatKartuInfo(
                        judul: 'Informasi Transaksi',
                        children: [
                          _buatBarisDetail(
                            ikon: Icons.tag_rounded,
                            label: 'ID Transaksi',
                            nilai: _transaksi.id,
                          ),
                          const Divider(height: 24),
                          _buatBarisDetail(
                            ikon: Icons.person_rounded,
                            label: 'Nama Pembeli',
                            nilai: _transaksi.namaPembeli,
                          ),
                          const Divider(height: 24),
                          _buatBarisDetail(
                            ikon: Icons.shopping_bag_rounded,
                            label: 'Jumlah Pembelian',
                            nilai: '${_transaksi.jumlahPembelian} item',
                          ),
                          const Divider(height: 24),
                          _buatBarisDetail(
                            ikon: Icons.calendar_today_rounded,
                            label: 'Tanggal Pembelian',
                            nilai: formatTanggal.format(
                              _transaksi.tanggalPembelian,
                            ),
                          ),
                          const Divider(height: 24),
                          _buatBarisDetail(
                            ikon: Icons.payment_rounded,
                            label: 'Metode Pembelian',
                            nilai: _transaksi.metodePembelian,
                          ),
                          if (_transaksi.nomorResep != null) ...[
                            const Divider(height: 24),
                            _buatBarisDetail(
                              ikon: Icons.assignment_rounded,
                              label: 'Nomor Resep',
                              nilai: _transaksi.nomorResep!,
                            ),
                          ],
                          if (_transaksi.catatan.isNotEmpty) ...[
                            const Divider(height: 24),
                            _buatBarisDetail(
                              ikon: Icons.note_rounded,
                              label: 'Catatan',
                              nilai: _transaksi.catatan,
                            ),
                          ],
                          const Divider(height: 24),
                          _buatBarisDetail(
                            ikon: Icons.info_rounded,
                            label: 'Status',
                            nilai: _transaksi.status == 'selesai'
                                ? 'Selesai'
                                : 'Dibatalkan',
                            warnaNilai: _transaksi.status == 'selesai'
                                ? Colors.green[600]
                                : Colors.red[600],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buatKartuRingkasan(formatter),
                      const SizedBox(height: 30),
                      _buatTombolAksi(),
                    ],
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Pembelian',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Informasi lengkap transaksi',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatKartuObat() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.pink[100]!, Colors.pink[50]!]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.pink[200]!.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GambarObat(
              urlGambar: _transaksi.gambarObat,
              lebar: 100,
              tinggi: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _transaksi.kategoriObat,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _transaksi.namaObat,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ID: ${_transaksi.idObat}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.pink[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatKartuInfo({
    required String judul,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buatBarisDetail({
    required IconData ikon,
    required String label,
    required String nilai,
    Color? warnaNilai,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.pink[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(ikon, size: 22, color: Colors.pink[500]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                nilai,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: warnaNilai ?? Colors.pink[900],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buatKartuRingkasan(NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink[600]!, Colors.pink[400]!],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.pink[400]!.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Ringkasan Pembayaran',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buatBarisRingkasan(
            'Harga Satuan',
            'Rp ${formatter.format(_transaksi.hargaSatuan)}',
          ),
          const SizedBox(height: 12),
          _buatBarisRingkasan('Jumlah Item', '${_transaksi.jumlahPembelian} x'),
          const Divider(color: Colors.white, thickness: 1.5, height: 32),
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
                'Rp ${formatter.format(_transaksi.totalHarga)}',
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
            fontSize: 15,
            color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          nilai,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buatTombolAksi() {
    return Column(
      children: [
        if (_transaksi.status == 'selesai')
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
            child: ElevatedButton.icon(
              onPressed: () async {
                final hasil = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HalamanEditTransaksi(transaksi: _transaksi),
                  ),
                );
                if (hasil != null && hasil is Transaksi && mounted) {
                  setState(() {
                    _transaksi = hasil;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              label: Text(
                'EDIT TRANSAKSI',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (_transaksi.status == 'selesai') const SizedBox(height: 16),
        Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.red[400]!, Colors.red[600]!],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red[300]!.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _transaksi.status == 'selesai'
                ? _konfirmasiBatalkan
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.grey[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: Icon(
              Icons.cancel_rounded,
              color: _transaksi.status == 'selesai'
                  ? Colors.white
                  : Colors.grey[600],
            ),
            label: Text(
              'BATALKAN TRANSAKSI',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: _transaksi.status == 'selesai'
                    ? Colors.white
                    : Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
