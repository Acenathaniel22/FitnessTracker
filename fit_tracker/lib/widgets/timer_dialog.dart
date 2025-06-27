import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color(0xFF1E1E1E),
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
              color: Colors.white70,
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
                      backgroundColor: Colors.grey[800],
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
                      color: Colors.white,
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              elevation: 8,
              shadowColor: primaryColor.withOpacity(0.4),
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
