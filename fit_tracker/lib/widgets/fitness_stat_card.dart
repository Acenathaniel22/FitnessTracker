import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FitnessStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color textColor;
  final Color? cardColor;
  final Color primaryColor;

  const FitnessStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.textColor,
    required this.cardColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: textColor, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.robotoCondensed(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.robotoCondensed(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
