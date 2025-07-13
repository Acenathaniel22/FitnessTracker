import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme_colors.dart';

class RoutineTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final int duration;
  final bool isDone;
  final VoidCallback? onTap;
  final Color textColor;
  final Color? cardColor;
  final Color primaryColor;
  final String? bodyPart;

  const RoutineTile({
    super.key,
    required this.label,
    required this.icon,
    required this.duration,
    required this.isDone,
    this.onTap,
    required this.textColor,
    required this.cardColor,
    required this.primaryColor,
    this.bodyPart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDone ? 0.5 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDone ? ThemeColors.successColor : primaryColor,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.getMutedTextColor(true).withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Accent bar
              Container(
                width: 6,
                height: 56,
                decoration: BoxDecoration(
                  color: isDone ? ThemeColors.successColor : primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(icon, color: textColor, size: 26),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    if (bodyPart != null && bodyPart!.isNotEmpty)
                      Text(
                        bodyPart!,
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 13,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
              if (isDone)
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.check_circle,
                    color: ThemeColors.successColor,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
