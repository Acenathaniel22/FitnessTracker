import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(GymDashboardApp());
}

class GymDashboardApp extends StatefulWidget {
  @override
  State<GymDashboardApp> createState() => _GymDashboardAppState();
}

class _GymDashboardAppState extends State<GymDashboardApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Routine Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.robotoCondensedTextTheme(
          ThemeData.light().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        colorScheme: const ColorScheme.light().copyWith(
          primary: Color(0xFFFF2D2D),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.robotoCondensedTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Color(0xFFFF2D2D),
        ),
      ),
      themeMode: _themeMode,
      home: GymDashboard(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}

class GymDashboard extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  const GymDashboard({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<GymDashboard> createState() => _GymDashboardState();
}

class _GymDashboardState extends State<GymDashboard> {
  bool started = false;
  String selectedDay = _getTodayName();

  static String _getTodayName() {
    final now = DateTime.now().weekday;
    // In Dart, weekday: 1=Monday, ..., 7=Sunday
    return [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ][now % 7];
  }

  final Map<String, List<Map<String, dynamic>>> weeklyRoutine = const {
    'Monday': [
      {
        'label': "Warm-up: 10 min treadmill",
        'icon': Icons.directions_run,
        'duration': 10,
        'steps': 1200,
        'calories': 80,
        'workout': 10,
      },
      {
        'label': "Bench Press - 4 Sets",
        'icon': Icons.fitness_center,
        'duration': 10,
        'steps': 100,
        'calories': 50,
        'workout': 3,
      },
      {
        'label': "Tricep Pushdowns - 3 Sets",
        'icon': Icons.cable,
        'duration': 10,
        'steps': 80,
        'calories': 30,
        'workout': 2,
      },
    ],
    'Tuesday': [
      {
        'label': "Pull-ups - 3 Sets",
        'icon': Icons.fitness_center,
        'duration': 10,
        'steps': 60,
        'calories': 25,
        'workout': 2,
      },
      {
        'label': "Deadlifts - 4 Sets",
        'icon': Icons.sports_kabaddi,
        'duration': 10,
        'steps': 90,
        'calories': 60,
        'workout': 3,
      },
      {
        'label': "Barbell Rows - 3 Sets",
        'icon': Icons.cable,
        'duration': 10,
        'steps': 70,
        'calories': 35,
        'workout': 2,
      },
    ],
    'Wednesday': [
      {
        'label': "Squats - 4 Sets",
        'icon': Icons.directions_run,
        'duration': 10,
        'steps': 110,
        'calories': 55,
        'workout': 3,
      },
      {
        'label': "Lunges - 3 Sets",
        'icon': Icons.directions_walk,
        'duration': 10,
        'steps': 90,
        'calories': 30,
        'workout': 2,
      },
      {
        'label': "Leg Curls - 3 Sets",
        'icon': Icons.fitness_center,
        'duration': 10,
        'steps': 60,
        'calories': 25,
        'workout': 2,
      },
    ],
    'Thursday': [
      {
        'label': "Shoulder Press - 4 Sets",
        'icon': Icons.fitness_center,
        'duration': 10,
        'steps': 60,
        'calories': 40,
        'workout': 3,
      },
      {
        'label': "Lateral Raises - 3 Sets",
        'icon': Icons.trending_up,
        'duration': 10,
        'steps': 40,
        'calories': 20,
        'workout': 2,
      },
      {
        'label': "Front Raises - 3 Sets",
        'icon': Icons.trending_up,
        'duration': 10,
        'steps': 40,
        'calories': 20,
        'workout': 2,
      },
    ],
    'Friday': [
      {
        'label': "Chest Fly - 4 Sets",
        'icon': Icons.sports_mma,
        'duration': 10,
        'steps': 60,
        'calories': 45,
        'workout': 3,
      },
      {
        'label': "Pushups - 3 Sets",
        'icon': Icons.accessibility,
        'duration': 10,
        'steps': 50,
        'calories': 20,
        'workout': 2,
      },
      {
        'label': "Tricep Dips - 3 Sets",
        'icon': Icons.accessibility,
        'duration': 10,
        'steps': 50,
        'calories': 20,
        'workout': 2,
      },
    ],
    'Saturday': [
      {
        'label': "Rest & Recovery",
        'icon': Icons.spa,
        'duration': 0,
        'steps': 0,
        'calories': 0,
        'workout': 0,
      },
    ],
    'Sunday': [
      {
        'label': "Cardio: 20 min",
        'icon': Icons.directions_run,
        'duration': 10,
        'steps': 2500,
        'calories': 180,
        'workout': 20,
      },
      {
        'label': "Abs Workout - 3 Sets",
        'icon': Icons.fitness_center,
        'duration': 10,
        'steps': 40,
        'calories': 25,
        'workout': 2,
      },
      {
        'label': "Planks - 3 Sets",
        'icon': Icons.accessibility,
        'duration': 10,
        'steps': 20,
        'calories': 15,
        'workout': 3,
      },
    ],
  };

  Set<String> completedExercises = {};
  int steps = 0;
  int calories = 0;
  int workoutMinutes = 0;

  // Update the rest day logic and quotes to use Saturday instead of Sunday
  final List<String> restDayQuotes = [
    "Resting so hard, I might pull a muscle!",
    "My favorite exercise on rest day: diddly squats.",
    "Abs are made in the kitchen... and on the couch!",
    "Today's workout: 100 reps of relaxation.",
    "If you need me, I'll be busy not moving.",
    "Rest day: Because even superheroes need a day off!",
    "Rest day: the only day my gym clothes are safe from sweat.",
    "I'm not lazy, I'm on energy-saving mode!",
    "Couch marathon: Level Expert.",
    "Resting is a workout too, right?",
  ];

  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );
  bool showCongrats = false;

  void _showTimerDialog(String label, int duration) async {
    final routine = weeklyRoutine[selectedDay] ?? [];
    final exercise = routine.firstWhere(
      (e) => e['label'] == label,
      orElse: () => {},
    );
    // Instantly mark as done for rest day activities
    if (selectedDay == 'Saturday' && (label == 'Rest & Recovery')) {
      setState(() {
        completedExercises.add(label);
        steps += (exercise['steps'] ?? 0) as int;
        calories += (exercise['calories'] ?? 0) as int;
        workoutMinutes += (exercise['workout'] ?? 0) as int;
      });
      return;
    }
    final done = await showDialog<bool>(
      context: context,
      builder: (context) =>
          TimerDialog(exerciseLabel: label, duration: duration),
    );
    if (done == true) {
      setState(() {
        completedExercises.add(label);
        steps += (exercise['steps'] ?? 0) as int;
        calories += (exercise['calories'] ?? 0) as int;
        workoutMinutes += (exercise['workout'] ?? 0) as int;
        // Check if all exercises are done (not rest day)
        if (selectedDay != 'Saturday' &&
            completedExercises.length == routine.length) {
          showCongrats = true;
          _confettiController.play();
        }
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routine = weeklyRoutine[selectedDay] ?? [];
    final isRestDay = selectedDay == 'Saturday';
    final randomQuote = (restDayQuotes..shuffle()).first;
    final isDark = widget.themeMode == ThemeMode.dark;
    // Electric Blue & Black palette
    final primaryColor = const Color(0xFF2979FF); // Electric Blue
    final accentColor = isDark
        ? const Color(0xFF23272A)
        : const Color(0xFFE3F2FD); // Charcoal or light blue
    final cardColor = isDark
        ? const Color(0xFF2C2F33)
        : const Color(0xFFF5F7FA); // Slightly lighter for cards
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: accentColor,
            child: started
                ? ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      AppBar(
                        title: isRestDay
                            ? Text(
                                'REST DAY',
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              )
                            : Text(
                                'Daily Fit Tracker',
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                        centerTitle: false,
                        backgroundColor: primaryColor,
                        elevation: 0,
                        actions: [
                          IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode : Icons.dark_mode,
                              color: Colors.white,
                            ),
                            tooltip: isDark
                                ? 'Switch to Light Mode'
                                : 'Switch to Dark Mode',
                            onPressed: widget.onToggleTheme,
                          ),
                        ],
                        systemOverlayStyle:
                            Theme.of(context).brightness == Brightness.dark
                            ? SystemUiOverlayStyle.light.copyWith(
                                systemNavigationBarColor: primaryColor,
                              )
                            : SystemUiOverlayStyle.dark.copyWith(
                                systemNavigationBarColor: primaryColor,
                              ),
                      ),
                      // Select Day row
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Select Day: ",
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Theme(
                              data: Theme.of(context).copyWith(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: DropdownButton<String>(
                                dropdownColor: cardColor,
                                value: selectedDay,
                                iconEnabledColor: primaryColor,
                                style: TextStyle(color: textColor),
                                underline: Container(
                                  height: 2,
                                  color: primaryColor,
                                ),
                                isDense: true,
                                items:
                                    [
                                      'Sunday',
                                      'Monday',
                                      'Tuesday',
                                      'Wednesday',
                                      'Thursday',
                                      'Friday',
                                      'Saturday',
                                    ].map((day) {
                                      return DropdownMenuItem<String>(
                                        value: day,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0,
                                          ),
                                          child: Text(
                                            day,
                                            style: TextStyle(color: textColor),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (String? newDay) {
                                  setState(() {
                                    selectedDay = newDay!;
                                    completedExercises.clear();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isRestDay ? "REST & RECOVERY" : "$selectedDay Routine",
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isRestDay) ...[
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.spa,
                                color: Colors.greenAccent,
                                size: 80,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                randomQuote,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoCondensed(
                                  color: textColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Progress bar for daily completion (except rest day)
                        if (routine.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: routine.isEmpty
                                      ? 0
                                      : completedExercises.length /
                                            routine.length,
                                  minHeight: 10,
                                  backgroundColor: cardColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${completedExercises.length}/${routine.length} completed',
                                  style: GoogleFonts.robotoCondensed(
                                    color: textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        ...routine.map((exercise) {
                          final isDone = completedExercises.contains(
                            exercise['label'],
                          );
                          final duration = exercise['duration'] ?? 60;
                          return RoutineTile(
                            label: exercise['label'],
                            icon: exercise['icon'],
                            duration: duration,
                            isDone: isDone,
                            onTap: isDone
                                ? null
                                : () => _showTimerDialog(
                                    exercise['label'],
                                    duration,
                                  ),
                            textColor: textColor,
                            cardColor: cardColor,
                            primaryColor: primaryColor,
                          );
                        }),
                      ],
                      const SizedBox(height: 30),
                      Text(
                        "Fitness Tracker",
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          FitnessStatCard(
                            label: "Steps",
                            value: steps.toString(),
                            icon: Icons.directions_walk,
                            textColor: textColor,
                            cardColor: cardColor,
                            primaryColor: primaryColor,
                          ),
                          FitnessStatCard(
                            label: "Calories",
                            value: "$calories kcal",
                            icon: Icons.local_fire_department,
                            textColor: textColor,
                            cardColor: cardColor,
                            primaryColor: primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          FitnessStatCard(
                            label: "Water",
                            value: "2.0 L",
                            icon: Icons.water_drop,
                            textColor: textColor,
                            cardColor: cardColor,
                            primaryColor: primaryColor,
                          ),
                          FitnessStatCard(
                            label: "Workout",
                            value: "${workoutMinutes}m",
                            icon: Icons.timer,
                            textColor: textColor,
                            cardColor: cardColor,
                            primaryColor: primaryColor,
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          color: Colors.redAccent,
                          size: 100,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Ready to Crush It?",
                          style: GoogleFonts.bebasNeue(
                            fontSize: 36,
                            color: Colors.black,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Your daily gym plan awaits.",
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              started = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 10,
                            shadowColor: Colors.redAccent.withOpacity(0.5),
                          ),
                          child: const Text(
                            "START",
                            style: TextStyle(
                              fontSize: 22,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          // Confetti and congrats overlay
          if (showCongrats)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 32,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: primaryColor,
                          size: 64,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Congratulations!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoCondensed(
                            color: primaryColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'You finished all your exercises today! 🎉',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoCondensed(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showCongrats = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.orange,
                      Colors.purple,
                    ],
                    numberOfParticles: 30,
                    maxBlastForce: 20,
                    minBlastForce: 8,
                    emissionFrequency: 0.05,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class RoutineTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final int duration;
  final bool isDone;
  final VoidCallback? onTap;
  final Color textColor;
  final Color? cardColor;
  final Color primaryColor;

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
              color: isDone ? Colors.green : primaryColor,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
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
                  color: isDone ? Colors.green : primaryColor,
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
                child: Text(
                  label,
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              if (isDone)
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
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

  @override
  void initState() {
    super.initState();
    remaining = widget.duration;
    running = true;
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
                    Navigator.of(context).pop(true);
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
