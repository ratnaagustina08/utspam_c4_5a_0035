import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/pengguna.dart';
import '../model/transaksi.dart';

class ServicePenyimpanan {
  static const String _kunciPengguna = 'daftar_pengguna';
  static const String _kunciPenggunaAktif = 'pengguna_aktif';
  static const String _kunciTransaksi = 'daftar_transaksi';

  Future<bool> simpanPengguna(Pengguna pengguna) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final daftarPenggunaString = prefs.getString(_kunciPengguna) ?? '[]';
      final List<dynamic> daftarPengguna = json.decode(daftarPenggunaString);

      for (var p in daftarPengguna) {
        if (p['username'] == pengguna.username) {
          return false;
        }
      }

      daftarPengguna.add(pengguna.keMap());
      await prefs.setString(_kunciPengguna, json.encode(daftarPengguna));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Pengguna?> login(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final daftarPenggunaString = prefs.getString(_kunciPengguna) ?? '[]';
      final List<dynamic> daftarPengguna = json.decode(daftarPenggunaString);

      for (var p in daftarPengguna) {
        if (p['username'] == username && p['password'] == password) {
          final pengguna = Pengguna.dariMap(p);
          await prefs.setString(
            _kunciPenggunaAktif,
            json.encode(pengguna.keMap()),
          );
          return pengguna;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Pengguna?> dapatkanPenggunaAktif() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final penggunaString = prefs.getString(_kunciPenggunaAktif);
      if (penggunaString != null) {
        return Pengguna.dariMap(json.decode(penggunaString));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kunciPenggunaAktif);
  }

  Future<bool> simpanTransaksi(Transaksi transaksi) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pengguna = await dapatkanPenggunaAktif();
      if (pengguna == null) return false;

      final kunciTransaksiPengguna = '${_kunciTransaksi}_${pengguna.username}';
      final daftarTransaksiString =
          prefs.getString(kunciTransaksiPengguna) ?? '[]';
      final List<dynamic> daftarTransaksi = json.decode(daftarTransaksiString);

      daftarTransaksi.add(transaksi.keMap());
      await prefs.setString(
        kunciTransaksiPengguna,
        json.encode(daftarTransaksi),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Transaksi>> dapatkanSemuaTransaksi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pengguna = await dapatkanPenggunaAktif();
      if (pengguna == null) return [];

      final kunciTransaksiPengguna = '${_kunciTransaksi}_${pengguna.username}';
      final daftarTransaksiString =
          prefs.getString(kunciTransaksiPengguna) ?? '[]';
      final List<dynamic> daftarTransaksi = json.decode(daftarTransaksiString);

      return daftarTransaksi.map((t) => Transaksi.dariMap(t)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> perbaruiTransaksi(Transaksi transaksi) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pengguna = await dapatkanPenggunaAktif();
      if (pengguna == null) return false;

      final kunciTransaksiPengguna = '${_kunciTransaksi}_${pengguna.username}';
      final daftarTransaksiString =
          prefs.getString(kunciTransaksiPengguna) ?? '[]';
      final List<dynamic> daftarTransaksi = json.decode(daftarTransaksiString);

      for (int i = 0; i < daftarTransaksi.length; i++) {
        if (daftarTransaksi[i]['id'] == transaksi.id) {
          daftarTransaksi[i] = transaksi.keMap();
          await prefs.setString(
            kunciTransaksiPengguna,
            json.encode(daftarTransaksi),
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hapusTransaksi(String idTransaksi) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pengguna = await dapatkanPenggunaAktif();
      if (pengguna == null) return false;

      final kunciTransaksiPengguna = '${_kunciTransaksi}_${pengguna.username}';
      final daftarTransaksiString =
          prefs.getString(kunciTransaksiPengguna) ?? '[]';
      final List<dynamic> daftarTransaksi = json.decode(daftarTransaksiString);

      daftarTransaksi.removeWhere((t) => t['id'] == idTransaksi);
      await prefs.setString(
        kunciTransaksiPengguna,
        json.encode(daftarTransaksi),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
