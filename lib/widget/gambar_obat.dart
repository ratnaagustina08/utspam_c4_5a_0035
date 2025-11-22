import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GambarObat extends StatelessWidget {
  final String urlGambar;
  final double? lebar;
  final double? tinggi;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const GambarObat({
    super.key,
    required this.urlGambar,
    this.lebar,
    this.tinggi,
    this.fit,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        urlGambar,
        width: lebar,
        height: tinggi,
        fit: fit ?? BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: lebar,
            height: tinggi,
            color: Colors.pink[50],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: Colors.pink[400],
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: lebar,
            height: tinggi,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[200]!],
              ),
              borderRadius: borderRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_rounded, size: 40, color: Colors.grey[600]),
                const SizedBox(height: 8),
                Text(
                  'Tidak Ada Internet',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
