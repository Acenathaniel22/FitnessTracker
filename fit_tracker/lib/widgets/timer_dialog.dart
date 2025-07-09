import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme_colors.dart';

class TimerDialog extends StatefulWidget {
  final String exerciseLabel;
  final int duration;
  const TimerDialog({
    super.key,
    required this.exerciseLabel,
    required this.duration,
  });

  @override
  State<TimerDialog> createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog>
    with SingleTickerProviderStateMixin {
  late int remaining;
  late bool running;
  late AnimationController _controller;
  late int secondsSpent;

  @override
  void initState() {
    super.initState();
    remaining = widget.duration;
    running = true;
    secondsSpent = 0;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..forward();
    _startTimer();
  }

  void _startTimer() async {
    while (running && remaining > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        remaining--;
        secondsSpent++;
      });
    }
    if (mounted && remaining == 0) {
      running = false;
      // Optionally, play a sound or vibrate here
    }
  }

  @override
  void dispose() {
    running = false;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = 1 - (remaining / widget.duration);
    final primaryColor = const Color(0xFF2979FF);
    return AlertDialog(
      backgroundColor: ThemeColors.getCardColor(true),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Column(
        children: [
          Text(
            widget.exerciseLabel,
            textAlign: TextAlign.center,
            style: GoogleFonts.robotoCondensed(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            remaining > 0 ? "Keep Going!" : "Great Job!",
            style: GoogleFonts.robotoCondensed(
              color: ThemeColors.getMutedTextColor(true),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 10,
                      backgroundColor: ThemeColors.getCardColor(true),
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    '${remaining ~/ 60}:${(remaining % 60).toString().padLeft(2, '0')}',
                    style: GoogleFonts.bebasNeue(
                      color: ThemeColors.getTextColor(true),
                      fontSize: 54,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: primaryColor.withOpacity(0.7),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: ThemeColors.getCardColor(true),
                      title: Text(
                        'Quit Exercise?',
                        style: TextStyle(color: ThemeColors.getTextColor(true)),
                      ),
                      content: Text(
                        'Are you sure you want to quit?',
                        style: TextStyle(
                          color: ThemeColors.getMutedTextColor(true),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            'Quit',
                            style: TextStyle(color: ThemeColors.errorColor),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    running = false;
                    Navigator.of(context).pop(-1); // Special value for quit
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.getCardColor(true),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  elevation: 4,
                  shadowColor: primaryColor.withOpacity(0.2),
                ),
                child: Text(
                  'Quit',
                  style: TextStyle(
                    color: ThemeColors.getTextColor(true),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: remaining == 0
                    ? () {
                        running = false;
                        Navigator.of(context).pop(secondsSpent);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: ThemeColors.getTextColor(true),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
