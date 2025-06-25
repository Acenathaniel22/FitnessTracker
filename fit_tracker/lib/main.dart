import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const GymRoutineApp());

class GymRoutineApp extends StatelessWidget {
  const GymRoutineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.redAccent,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fitness_center, size: 100, color: Colors.redAccent),
              const SizedBox(height: 20),
              const Text(
                "Welcome to RedFit Gym Routine",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GymRoutineHome()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "START",
                  style: TextStyle(fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GymRoutineHome extends StatelessWidget {
  const GymRoutineHome({super.key});

  final List<String> days = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: days.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weekly Gym Routine'),
          backgroundColor: Colors.black,
          bottom: TabBar(
            isScrollable: true,
            tabs: days.map((day) => Tab(text: day)).toList(),
          ),
        ),
        body: TabBarView(
          children: [
            RoutineCardList(routine: mondayRoutine),
            RoutineCardList(routine: tuesdayRoutine),
            RoutineCardList(routine: wednesdayRoutine),
            RoutineCardList(routine: thursdayRoutine),
            RoutineCardList(routine: fridayRoutine),
            RoutineCardList(routine: saturdayRoutine),
            RoutineCardList(routine: sundayRoutine, allowTimer: false),
          ],
        ),
      ),
    );
  }
}

class RoutineCardList extends StatelessWidget {
  final List<String> routine;
  final bool allowTimer;
  const RoutineCardList({super.key, required this.routine, this.allowTimer = true});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: routine.length,
      itemBuilder: (context, index) {
        return Card(
          color: const Color(0xFF1F1F1F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
              routine[index],
              style: const TextStyle(color: Colors.white),
            ),
            leading: const Icon(Icons.fitness_center, color: Colors.redAccent),
            onTap: () async {
              if (!allowTimer) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("🧘 It's a rest day! No timer needed."),
                    backgroundColor: Colors.blueGrey,
                  ),
                );
                return;
              }
              final duration = await showDialog<int>(
                context: context,
                builder: (context) {
                  int selectedSeconds = 30;
                  return AlertDialog(
                    backgroundColor: const Color(0xFF1F1F1F),
                    title: const Text("⏱️ Set Timer", style: TextStyle(color: Colors.redAccent)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Enter duration in seconds:", style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: selectedSeconds.toDouble(),
                                    min: 10,
                                    max: 180,
                                    divisions: 17,
                                    label: "$selectedSeconds sec",
                                    activeColor: Colors.redAccent,
                                    onChanged: (val) => setState(() => selectedSeconds = val.toInt()),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(selectedSeconds),
                        child: const Text("Start", style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  );
                },
              );
              if (duration != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoutineDetailPage(
                      exercise: routine[index],
                      durationSeconds: duration,
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}

class RoutineDetailPage extends StatefulWidget {
  final String exercise;
  final int durationSeconds;
  const RoutineDetailPage({super.key, required this.exercise, required this.durationSeconds});

  @override
  State<RoutineDetailPage> createState() => _RoutineDetailPageState();
}

class _RoutineDetailPageState extends State<RoutineDetailPage> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _completed = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Time's up! Great job!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final timeLeft = "$minutes:${seconds.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("🏋️ Exercise Timer"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _completed
                  ? const Icon(Icons.check_circle, size: 100, color: Colors.green)
                  : const Icon(Icons.timer, size: 100, color: Colors.redAccent),
              const SizedBox(height: 20),
              Text(
                widget.exercise,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _completed ? "✅ Completed!" : "⏱️ Time Left: $timeLeft",
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const mondayRoutine = [
  "Warm-up: Treadmill – 10 mins",
  "Bench Press – 4x10",
  "Incline Dumbbell Press – 3x12",
  "Chest Fly Machine – 3x12",
  "Triceps Dips – 3x10",
  "Triceps Pushdown – 3x12",
];

const tuesdayRoutine = [
  "Warm-up: Rowing – 10 mins",
  "Lat Pulldown – 4x10",
  "Seated Row – 3x10",
  "Dumbbell Bicep Curls – 3x12",
  "Hammer Curls – 3x10",
  "Face Pulls – 3x15",
];

const wednesdayRoutine = [
  "Warm-up: Leg Swings & Squats",
  "Barbell Squats – 4x8",
  "Leg Press – 3x12",
  "Romanian Deadlift – 3x10",
  "Calf Raises – 3x15",
  "Planks – 3 sets (1 min)",
  "Leg Raises – 3x15",
];

const thursdayRoutine = [
  "Active Recovery / Cardio",
  "Walk 30 mins or Cycle 20 mins",
  "Stretch or Yoga",
  "Foam Roll",
];

const fridayRoutine = [
  "Warm-up: Arm Circles",
  "Overhead Press – 4x8",
  "Lateral Raises – 3x12",
  "Front Raises – 3x12",
  "Shrugs – 3x15",
  "Russian Twists – 3x20",
  "Hanging Leg Raises – 3x10",
];

const saturdayRoutine = [
  "Warm-up: Jump Rope",
  "Deadlifts – 4x6",
  "Pull-ups – 3xMax",
  "Dumbbell Thrusters – 3x12",
  "Pushups – 3xFailure",
  "Mountain Climbers – 3x30 sec",
];

const sundayRoutine = [
  "Rest Day / Light Recovery",
];
