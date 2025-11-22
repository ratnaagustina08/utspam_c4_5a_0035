import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/pengguna.dart';
import '../service/service_penyimpanan.dart';

class HalamanProfil extends StatefulWidget {
  const HalamanProfil({super.key});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil> {
  final _servicePenyimpanan = ServicePenyimpanan();
  Pengguna? _pengguna;
  bool _sedangMemuat = true;

  @override
  void initState() {
    super.initState();
    _muatDataPengguna();
  }

  Future<void> _muatDataPengguna() async {
    setState(() {
      _sedangMemuat = true;
    });

    final pengguna = await _servicePenyimpanan.dapatkanPenggunaAktif();

    setState(() {
      _pengguna = pengguna;
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
                    : _pengguna == null
                    ? Center(
                        child: Text(
                          'Data tidak ditemukan',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.pink[700],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buatAvatarProfil(),
                            const SizedBox(height: 30),
                            _buatKartuInfo(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil Saya',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Informasi akun pengguna',
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

  Widget _buatAvatarProfil() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.pink[400]!, Colors.pink[600]!],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.pink[300]!.withOpacity(0.6),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              size: 80,
              color: Colors.pink[500],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _pengguna!.namaLengkap,
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.pink[900],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink[200]!, Colors.pink[300]!],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '@${_pengguna!.username}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buatKartuInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.pink[100]!.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Akun',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
          const SizedBox(height: 24),
          _buatItemInfo(
            ikon: Icons.email_rounded,
            judul: 'Email',
            konten: _pengguna!.email,
          ),
          const SizedBox(height: 20),
          _buatItemInfo(
            ikon: Icons.phone_rounded,
            judul: 'Nomor Telepon',
            konten: _pengguna!.nomorTelepon,
          ),
          const SizedBox(height: 20),
          _buatItemInfo(
            ikon: Icons.location_on_rounded,
            judul: 'Alamat',
            konten: _pengguna!.alamat,
          ),
          const SizedBox(height: 20),
          _buatItemInfo(
            ikon: Icons.account_circle_rounded,
            judul: 'Username',
            konten: _pengguna!.username,
          ),
        ],
      ),
    );
  }

  Widget _buatItemInfo({
    required IconData ikon,
    required String judul,
    required String konten,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink[50]!, Colors.pink[100]!.withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink[200]!, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink[400]!, Colors.pink[600]!],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(ikon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.pink[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  konten,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
