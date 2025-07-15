import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'dart:math'; // For number picker

// Import separated components
import 'widgets/routine_tile.dart';
import 'widgets/fitness_stat_card.dart';
import 'widgets/timer_dialog.dart';
import 'data/workout_data.dart';
import 'utils/theme_colors.dart';
import 'settings_screen.dart'; // <-- Add this import
import 'login_screen.dart';
import 'widgets/dialogs.dart';
import 'utils/exercise_constants.dart';

// Helper to format seconds as Xm Ys
String formatMinutesSeconds(int totalSeconds) {
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  return '${m}m ${s}s';
}

void main() {
  runApp(GymDashboardApp());
}

class GymDashboardApp extends StatefulWidget {
  const GymDashboardApp({Key? key}) : super(key: key);

  @override
  State<GymDashboardApp> createState() => _GymDashboardAppState();
}

class _GymDashboardAppState extends State<GymDashboardApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _loggedIn = false;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  void _login() {
    setState(() {
      _loggedIn = true;
    });
  }

  // Add reset progress callback
  final GlobalKey<_GymDashboardState> _dashboardKey =
      GlobalKey<_GymDashboardState>();

  void _resetProgress() {
    _dashboardKey.currentState?.resetProgress();
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
        appBarTheme: AppBarTheme(
          backgroundColor: ThemeColors.primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.bebasNeue(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        colorScheme: ColorScheme.light().copyWith(
          primary: ThemeColors.primaryColor,
          secondary: ThemeColors.successColor,
          background: ThemeColors.getAccentColor(false),
        ),
        scaffoldBackgroundColor: ThemeColors.getAccentColor(false),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
            shadowColor: ThemeColors.primaryColor.withOpacity(0.5),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.robotoCondensedTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ThemeColors.primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.bebasNeue(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        colorScheme: ColorScheme.dark().copyWith(
          primary: ThemeColors.primaryColor,
          secondary: ThemeColors.successColor,
          background: ThemeColors.getAccentColor(true),
        ),
        scaffoldBackgroundColor: ThemeColors.getAccentColor(true),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
            shadowColor: ThemeColors.primaryColor.withOpacity(0.5),
          ),
        ),
      ),
      themeMode: _themeMode,
      home: _loggedIn
          ? GymDashboard(
              key: _dashboardKey,
              onToggleTheme: _toggleTheme,
              themeMode: _themeMode,
              onResetProgress: _resetProgress,
            )
          : LoginScreen(onLogin: _login),
    );
  }
}

class GymDashboard extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  final VoidCallback onResetProgress;
  const GymDashboard({
    Key? key,
    required this.onToggleTheme,
    required this.themeMode,
    required this.onResetProgress,
  }) : super(key: key);

  @override
  State<GymDashboard> createState() => _GymDashboardState();
}

class _GymDashboardState extends State<GymDashboard> {
  bool started = false;
  bool isLoading = false; // For START button
  String selectedDay = WorkoutData.getTodayName();

  // Weekly tracking data
  Map<String, Set<String>> weeklyCompletedExercises = {};
  Map<String, int> weeklySteps = {};
  Map<String, int> weeklyCalories = {};
  Map<String, int> weeklyWorkoutMinutes = {};
  Map<String, Map<String, int>> weeklyWorkoutSeconds =
      {}; // NEW: day -> {exerciseLabel: secondsSpent}

  // Current day tracking
  Set<String> completedExercises = {};
  int steps = 0;
  int calories = 0;
  int workoutMinutes = 0;

  // Store custom exercises for today only
  List<Map<String, dynamic>> customExercises = [];

  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );
  bool showCongrats = false;

  int _currentIndex = 0;

  // Initialize weekly data for the selected day
  void _initializeDayData(String day) {
    weeklyCompletedExercises[day] ??= {};
    weeklySteps[day] ??= 0;
    weeklyCalories[day] ??= 0;
    weeklyWorkoutMinutes[day] ??= 0;
    weeklyWorkoutSeconds[day] ??= {}; // NEW

    // Load current day's data
    completedExercises = Set.from(weeklyCompletedExercises[day] ?? {});
    steps = weeklySteps[day] ?? 0;
    calories = weeklyCalories[day] ?? 0;
    workoutMinutes =
        ((weeklyWorkoutSeconds[day]?.values.fold<int>(0, (sum, s) => sum + s) ??
                    0) /
                60)
            .ceil(); // NEW: real time
  }

  // Save current day's data
  void _saveDayData() {
    weeklyCompletedExercises[selectedDay] = Set.from(completedExercises);
    weeklySteps[selectedDay] = steps;
    weeklyCalories[selectedDay] = calories;
    weeklyWorkoutMinutes[selectedDay] = workoutMinutes;
    // weeklyWorkoutSeconds is updated live
  }

  // Get weekly totals
  Map<String, int> get _weeklyTotals {
    int totalSteps = 0;
    int totalCalories = 0;
    int totalWorkoutSeconds = 0; // CHANGED
    int totalCompletedExercises = 0;

    for (String day in weeklyCompletedExercises.keys) {
      // Get the routine for the day
      final routine = List<Map<String, dynamic>>.from(
        WorkoutData.weeklyRoutine[day] ?? [],
      );
      final completed = weeklyCompletedExercises[day] ?? {};
      // Steps: only for completed exercises with bodyPart Cardio or Legs
      totalSteps += routine
          .where(
            (e) =>
                completed.contains(e['label']) &&
                (e['bodyPart'] == 'Cardio' || e['bodyPart'] == 'Legs'),
          )
          .fold<int>(0, (sum, e) => sum + ((e['steps'] ?? 0) as int));
      // Calories: sum for all completed exercises
      totalCalories += routine
          .where((e) => completed.contains(e['label']))
          .fold<int>(0, (sum, e) => sum + ((e['calories'] ?? 0) as int));
      // Workout seconds: sum real time spent for all completed exercises
      final workoutSecondsMap = weeklyWorkoutSeconds[day] ?? {};
      totalWorkoutSeconds += workoutSecondsMap.values.fold<int>(
        0,
        (sum, s) => sum + s,
      );
      // Completed exercises count
      totalCompletedExercises += completed.length;
    }

    return {
      'steps': totalSteps,
      'calories': totalCalories,
      'workoutSeconds': totalWorkoutSeconds, // CHANGED
      'completedExercises': totalCompletedExercises,
    };
  }

  void _showTimerDialog(String label, int defaultDuration) async {
    final routine = List<Map<String, dynamic>>.from(
      WorkoutData.weeklyRoutine[selectedDay] ?? [],
    );
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
        // For rest day, no workout time is added
      });
      _saveDayData();
      return;
    }
    // Show preset dialog first
    final pickedDuration = await showDurationPresetDialog(
      context,
      defaultDuration,
    );
    if (pickedDuration == null) return; // User cancelled
    final secondsSpent = await showDialog<int>(
      context: context,
      builder: (context) =>
          TimerDialog(exerciseLabel: label, duration: pickedDuration),
    );
    // Only mark as done if timer completed (secondsSpent >= pickedDuration)
    if (secondsSpent != null && secondsSpent >= pickedDuration) {
      setState(() {
        completedExercises.add(label);
        steps += (exercise['steps'] ?? 0) as int;
        calories += (exercise['calories'] ?? 0) as int;
        // Save real time spent for this exercise
        weeklyWorkoutSeconds[selectedDay] ??= {};
        weeklyWorkoutSeconds[selectedDay]![label] = secondsSpent;
        // Update workoutMinutes for today (for legacy code)
        workoutMinutes =
            ((weeklyWorkoutSeconds[selectedDay]?.values.fold<int>(
                          0,
                          (sum, s) => sum + s,
                        ) ??
                        0) /
                    60)
                .ceil();
        // Check if all exercises are done (not rest day)
        if (selectedDay != 'Saturday' &&
            completedExercises.length == routine.length) {
          showCongrats = true;
          _confettiController.play();
        }
      });
      _saveDayData();
    } else if (secondsSpent == -1 ||
        (secondsSpent != null && secondsSpent < pickedDuration)) {
      // Show motivational dialog if user quits early
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Don't quit!"),
          content: const Text(
            "You can do it! Try to finish the full time for best results.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (!started) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            started = true;
          });
        }
      });
    }
    _initializeDayData(selectedDay);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routine = List<Map<String, dynamic>>.from(
      WorkoutData.weeklyRoutine[selectedDay] ?? [],
    );
    final isRestDay = selectedDay == 'Saturday';
    final randomQuote = (List<String>.from(
      WorkoutData.restDayQuotes,
    )..shuffle()).first;
    final isDark = widget.themeMode == ThemeMode.dark;

    // Get theme colors
    final primaryColor = ThemeColors.primaryColor;
    final accentColor = ThemeColors.getAccentColor(isDark);
    final cardColor = ThemeColors.getCardColor(isDark);
    final textColor = ThemeColors.getTextColor(isDark);

    return Scaffold(
      appBar: started
          ? AppBar(
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
                  icon: const Icon(Icons.settings, color: Colors.white),
                  tooltip: 'Settings',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          themeMode: widget.themeMode,
                          onToggleTheme: widget.onToggleTheme,
                          onResetProgress: widget.onResetProgress,
                        ),
                      ),
                    );
                  },
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
            )
          : null,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: accentColor,
            child: started
                ? IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildTodayScreen(context),
                      _buildWeeklyScreen(context),
                    ],
                  )
                : Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/start.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // START button at about 75% height
                      Align(
                        alignment: const Alignment(0, 0.75),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 5,
                          ),
                        ),
                      ),
                    ],
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
      bottomNavigationBar: started
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedItemColor: ThemeColors.primaryColor,
              unselectedItemColor:
                  Theme.of(context).brightness == Brightness.light
                  ? ThemeColors.primaryColor.withOpacity(0.5)
                  : ThemeColors.getMutedTextColor(isDark),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.today),
                  label: 'Today',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Weekly',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildTodayScreen(BuildContext context) {
    final routine = [
      ...List<Map<String, dynamic>>.from(
        WorkoutData.weeklyRoutine[selectedDay] ?? [],
      ),
      ...customExercises,
    ];
    final isRestDay = selectedDay == 'Saturday';
    final randomQuote = (List<String>.from(
      WorkoutData.restDayQuotes,
    )..shuffle()).first;
    final isDark = widget.themeMode == ThemeMode.dark;

    // Get theme colors
    final primaryColor = ThemeColors.primaryColor;
    final accentColor = ThemeColors.getAccentColor(isDark);
    final cardColor = ThemeColors.getCardColor(isDark);
    final textColor = ThemeColors.getTextColor(isDark);

    // NEW: Calculate total workout seconds for today
    final totalWorkoutSeconds =
        (weeklyWorkoutSeconds[selectedDay]?.values.fold<int>(
          0,
          (sum, s) => sum + s,
        ) ??
        0);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: accentColor,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Move Select Day row here
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
                        underline: Container(height: 2, color: primaryColor),
                        isDense: true,
                        items: WorkoutData.weekDays.map((day) {
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
                            _saveDayData(); // Save current day data
                            selectedDay = newDay!;
                            _initializeDayData(
                              selectedDay,
                            ); // Load new day data
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
              if (!isRestDay) ...[
                const SizedBox(height: 4),
                Text(
                  'Target: ' +
                      routine
                          .map((exercise) => exercise['bodyPart'] as String?)
                          .where((part) => part != null && part.isNotEmpty)
                          .toSet()
                          .join(', '),
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              if (isRestDay) ...[
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.spa,
                        color: ThemeColors.successColor,
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
                              : completedExercises.length / routine.length,
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
                // Add Exercise Button
                if (!isRestDay)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final newExercise = await showAddExerciseDialog(
                          context,
                          bodyPart: selectedDay == 'Saturday'
                              ? ''
                              : routine.isNotEmpty
                              ? routine.first['bodyPart'] ?? ''
                              : '',
                        );
                        if (newExercise != null) {
                          setState(() {
                            customExercises.add(newExercise);
                          });
                        }
                      },
                    ),
                  ),
                ...routine.map((exercise) {
                  final isDone = completedExercises.contains(exercise['label']);
                  final duration = exercise['duration'] ?? 60;
                  return RoutineTile(
                    label: exercise['label'],
                    icon: exercise['icon'],
                    duration: duration,
                    isDone: isDone,
                    onTap: isDone
                        ? null
                        : () => _showTimerDialog(exercise['label'], duration),
                    textColor: textColor,
                    cardColor: cardColor,
                    primaryColor: primaryColor,
                    bodyPart: exercise['bodyPart'] as String?,
                    onSelectTime: isDone
                        ? null
                        : () => _showTimerDialog(exercise['label'], duration),
                  );
                }),
              ],
              const SizedBox(height: 30),
              Text(
                "Today's Fitness Tracker",
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
                    label: "Completed",
                    value: "${completedExercises.length}/${routine.length}",
                    icon: Icons.check_circle,
                    textColor: textColor,
                    cardColor: cardColor,
                    primaryColor: primaryColor,
                  ),
                  FitnessStatCard(
                    label: "Calories",
                    value:
                        "${(routine.where((e) => completedExercises.contains(e['label'])).fold<int>(0, (sum, e) => sum + ((e['calories'] ?? 0) as int)))} kcal",
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
                    label: "Workout",
                    value: formatMinutesSeconds(totalWorkoutSeconds),
                    icon: Icons.timer,
                    textColor: textColor,
                    cardColor: cardColor,
                    primaryColor: primaryColor,
                  ),
                  FitnessStatCard(
                    label: "Steps",
                    value:
                        "${(routine.where((e) => completedExercises.contains(e['label']) && (e['bodyPart'] == 'Cardio' || e['bodyPart'] == 'Legs')).fold<int>(0, (sum, e) => sum + ((e['steps'] ?? 0) as int)))}",
                    icon: Icons.directions_walk,
                    textColor: textColor,
                    cardColor: cardColor,
                    primaryColor: primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyScreen(BuildContext context) {
    final isDark = widget.themeMode == ThemeMode.dark;
    final primaryColor = ThemeColors.primaryColor;
    final accentColor = ThemeColors.getAccentColor(isDark);
    final cardColor = ThemeColors.getCardColor(isDark);
    final textColor = ThemeColors.getTextColor(isDark);

    // Prepare weekly steps data for the chart
    final weekDays = WorkoutData.weekDays;
    // final stepsData = weekDays.map((d) => weeklySteps[d] ?? 0).toList();
    // Prepare body part distribution for the week
    final Map<String, int> bodyPartCounts = {};
    for (final day in weekDays) {
      final routine = List<Map<String, dynamic>>.from(
        WorkoutData.weeklyRoutine[day] ?? [],
      );
      for (final exercise in routine) {
        final part = exercise['bodyPart'] as String?;
        if (part != null && part.isNotEmpty) {
          bodyPartCounts[part] = (bodyPartCounts[part] ?? 0) + 1;
        }
      }
    }
    final bodyParts = bodyPartCounts.keys.toList();
    final bodyPartValues = bodyParts
        .map((p) => bodyPartCounts[p] ?? 0)
        .toList();

    // NEW: Get total workout seconds for the week
    final totalWorkoutSeconds = _weeklyTotals['workoutSeconds'] ?? 0;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: accentColor,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Redesigned Weekly Progress Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.15),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: primaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Weekly Progress",
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWeeklyStatCard(
                          "Steps",
                          "${_weeklyTotals['steps']}",
                          Icons.directions_walk,
                          textColor,
                          primaryColor,
                        ),
                        _buildWeeklyStatCard(
                          "Calories",
                          "${_weeklyTotals['calories']} kcal",
                          Icons.local_fire_department,
                          textColor,
                          primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWeeklyStatCard(
                          "Workout",
                          formatMinutesSeconds(totalWorkoutSeconds),
                          Icons.timer,
                          textColor,
                          primaryColor,
                        ),
                        _buildWeeklyStatCard(
                          "Done",
                          "${_weeklyTotals['completedExercises']}",
                          Icons.check_circle,
                          textColor,
                          primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Chart removed since WeeklyBarChart is no longer available
              // Remove extra vertical space here
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyStatCard(
    String label,
    String value,
    IconData icon,
    Color textColor,
    Color primaryColor,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.13)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryColor, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.robotoCondensed(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.robotoCondensed(
                color: primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void resetProgress() {
    setState(() {
      weeklyCompletedExercises.clear();
      weeklySteps.clear();
      weeklyCalories.clear();
      weeklyWorkoutMinutes.clear();
      weeklyWorkoutSeconds.clear(); // NEW
      completedExercises.clear();
      steps = 0;
      calories = 0;
      workoutMinutes = 0;
      showCongrats = false;
    });
  }
}
