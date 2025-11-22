import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/pengguna.dart';
import '../service/service_penyimpanan.dart';

class HalamanRegistrasi extends StatefulWidget {
  const HalamanRegistrasi({super.key});

  @override
  State<HalamanRegistrasi> createState() => _HalamanRegistrasiState();
}

class _HalamanRegistrasiState extends State<HalamanRegistrasi> {
  final _formKey = GlobalKey<FormState>();
  final _namaLengkapController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorTeleponController = TextEditingController();
  final _alamatController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _servicePenyimpanan = ServicePenyimpanan();
  bool _passwordTersembunyi = true;
  bool _sedangMemproses = false;

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _emailController.dispose();
    _nomorTeleponController.dispose();
    _alamatController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validasiNamaLengkap(String? nilai) {
    if (nilai == null || nilai.isEmpty) {
      return 'Nama lengkap wajib diisi';
    }
    if (nilai.length < 3) {
      return 'Nama lengkap minimal 3 karakter';
    }
    return null;
  }

  String? _validasiEmail(String? nilai) {
    if (nilai == null || nilai.isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(nilai)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validasiNomorTelepon(String? nilai) {
    if (nilai == null || nilai.isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(nilai)) {
      return 'Nomor telepon hanya boleh berisi angka';
    }
    if (nilai.length < 10 || nilai.length > 13) {
      return 'Nomor telepon harus 10-13 digit';
    }
    return null;
  }

  String? _validasiAlamat(String? nilai) {
    if (nilai == null || nilai.isEmpty) {
      return 'Alamat wajib diisi';
    }
    if (nilai.length < 10) {
      return 'Alamat minimal 10 karakter';
    }
    return null;
  }

  String? _validasiUsername(String? nilai) {
    if (nilai == null || nilai.isEmpty) {
      return 'Username wajib diisi';
    }
    if (nilai.length < 4) {
      return 'Username minimal 4 karakter';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(nilai)) {
      return 'Username hanya boleh huruf, angka, dan underscore';
    }
    return null;
  }

  String? _validasiPassword(String? nilai) {
    if (nilai == null || nilai.isEmpty) {
      return 'Password wajib diisi';
    }
    if (nilai.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  Future<void> _daftarPengguna() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _sedangMemproses = true;
      });

      final pengguna = Pengguna(
        namaLengkap: _namaLengkapController.text.trim(),
        email: _emailController.text.trim(),
        nomorTelepon: _nomorTeleponController.text.trim(),
        alamat: _alamatController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      final berhasil = await _servicePenyimpanan.simpanPengguna(pengguna);

      setState(() {
        _sedangMemproses = false;
      });

      if (mounted) {
        if (berhasil) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Registrasi berhasil! Silakan login.',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Colors.pink[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Username sudah terdaftar. Gunakan username lain.',
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
            colors: [Colors.pink[50]!, Colors.pink[100]!, Colors.pink[200]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink[300]!.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.medical_services_rounded,
                      size: 60,
                      color: Colors.pink[400],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Daftar Akun Baru',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[800],
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bergabunglah dengan Apotek Vera',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.pink[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buatKolomInput(
                    controller: _namaLengkapController,
                    label: 'Nama Lengkap',
                    ikon: Icons.person_outline_rounded,
                    validator: _validasiNamaLengkap,
                  ),
                  const SizedBox(height: 20),
                  _buatKolomInput(
                    controller: _emailController,
                    label: 'Email',
                    ikon: Icons.email_outlined,
                    tipeKeyboard: TextInputType.emailAddress,
                    validator: _validasiEmail,
                  ),
                  const SizedBox(height: 20),
                  _buatKolomInput(
                    controller: _nomorTeleponController,
                    label: 'Nomor Telepon',
                    ikon: Icons.phone_outlined,
                    tipeKeyboard: TextInputType.phone,
                    validator: _validasiNomorTelepon,
                  ),
                  const SizedBox(height: 20),
                  _buatKolomInput(
                    controller: _alamatController,
                    label: 'Alamat',
                    ikon: Icons.home_outlined,
                    maksBaris: 3,
                    validator: _validasiAlamat,
                  ),
                  const SizedBox(height: 20),
                  _buatKolomInput(
                    controller: _usernameController,
                    label: 'Username',
                    ikon: Icons.account_circle_outlined,
                    validator: _validasiUsername,
                  ),
                  const SizedBox(height: 20),
                  _buatKolomInput(
                    controller: _passwordController,
                    label: 'Password',
                    ikon: Icons.lock_outline_rounded,
                    tersembunyi: _passwordTersembunyi,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordTersembunyi
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.pink[300],
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordTersembunyi = !_passwordTersembunyi;
                        });
                      },
                    ),
                    validator: _validasiPassword,
                  ),
                  const SizedBox(height: 35),
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
                      onPressed: _sedangMemproses ? null : _daftarPengguna,
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
                              'DAFTAR SEKARANG',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.pink[700],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Login di sini',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buatKolomInput({
    required TextEditingController controller,
    required String label,
    required IconData ikon,
    TextInputType? tipeKeyboard,
    bool tersembunyi = false,
    int maksBaris = 1,
    Widget? suffixIcon,
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
        obscureText: tersembunyi,
        keyboardType: tipeKeyboard,
        maxLines: tersembunyi ? 1 : maksBaris,
        style: GoogleFonts.poppins(fontSize: 15, color: Colors.pink[900]),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.pink[400],
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(ikon, color: Colors.pink[400]),
          suffixIcon: suffixIcon,
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
