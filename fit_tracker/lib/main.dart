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
      home: const GymRoutineHome(),
    );
  }
}

class GymRoutineHome extends StatelessWidget {
  const GymRoutineHome({super.key});

  final List<String> days = const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

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
            RoutineCardList(routine: sundayRoutine),
          ],
        ),
      ),
    );
  }
}

class RoutineCardList extends StatelessWidget {
  final List<String> routine;
  const RoutineCardList({super.key, required this.routine});

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
          ),
        );
      },
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
  "Brisk walk – 20 mins",
  "Light foam rolling",
  "Hydrate & stretch",
];
