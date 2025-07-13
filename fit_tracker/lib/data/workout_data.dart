import 'package:flutter/material.dart';

class WorkoutData {
  static const Map<String, List<Map<String, dynamic>>> weeklyRoutine = {
    'Monday': [
      {
        'label': "Warm-up: 10 min treadmill",
        'icon': Icons.directions_run,
        'duration': 10,
        'steps': 1200,
        'calories': 80,
        'workout': 10,
        'bodyPart': 'Cardio',
        'distance': 1, // 1 km
      },
      {
        'label': "Bench Press - 4 Sets",
        'icon': Icons.fitness_center,
        'duration': 10,
        'steps': 100,
        'calories': 50,
        'workout': 3,
        'bodyPart': 'Chest',
        'weight': 50, // 50 kg
      },
      {
        'label': "Tricep Pushdowns - 3 Sets",
        'icon': Icons.cable,
        'duration': 10,
        'steps': 80,
        'calories': 30,
        'workout': 2,
        'bodyPart': 'Arms',
        'weight': 30, // 30 kg
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
        'bodyPart': 'Back',
      },
      {
        'label': "Deadlifts - 4 Sets",
        'icon': Icons.sports_kabaddi,
        'duration': 10,
        'steps': 90,
        'calories': 60,
        'workout': 3,
        'bodyPart': 'Back',
      },
      {
        'label': "Barbell Rows - 3 Sets",
        'icon': Icons.cable,
        'duration': 10,
        'steps': 70,
        'calories': 35,
        'workout': 2,
        'bodyPart': 'Back',
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
        'bodyPart': 'Legs',
      },
      {
        'label': "Lunges - 3 Sets",
        'icon': Icons.directions_walk,
        'duration': 10,
        'steps': 90,
        'calories': 30,
        'workout': 2,
        'bodyPart': 'Legs',
      },
      {
        'label': "Leg Curls - 3 Sets",
        'icon': Icons.fitness_center,
        'duration': 10,
        'steps': 60,
        'calories': 25,
        'workout': 2,
        'bodyPart': 'Legs',
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
        'bodyPart': 'Shoulders',
      },
      {
        'label': "Lateral Raises - 3 Sets",
        'icon': Icons.trending_up,
        'duration': 10,
        'steps': 40,
        'calories': 20,
        'workout': 2,
        'bodyPart': 'Shoulders',
      },
      {
        'label': "Front Raises - 3 Sets",
        'icon': Icons.trending_up,
        'duration': 10,
        'steps': 40,
        'calories': 20,
        'workout': 2,
        'bodyPart': 'Shoulders',
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
        'bodyPart': 'Chest',
      },
      {
        'label': "Pushups - 3 Sets",
        'icon': Icons.accessibility,
        'duration': 10,
        'steps': 50,
        'calories': 20,
        'workout': 2,
        'bodyPart': 'Chest',
      },
      {
        'label': "Tricep Dips - 3 Sets",
        'icon': Icons.accessibility,
        'duration': 10,
        'steps': 50,
        'calories': 20,
        'workout': 2,
        'bodyPart': 'Arms',
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
        'bodyPart': 'Full Body',
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
        'bodyPart': 'Cardio',
        'distance': 2, // 2 km
      },
      {
        'label': "Abs Workout - 3 Sets",
        'icon': Icons.fitness_center,
        'duration': 10,
        'steps': 40,
        'calories': 25,
        'workout': 2,
        'bodyPart': 'Core',
      },
      {
        'label': "Planks - 3 Sets",
        'icon': Icons.accessibility,
        'duration': 10,
        'steps': 20,
        'calories': 15,
        'workout': 3,
        'bodyPart': 'Core',
      },
    ],
  };

  static const List<String> restDayQuotes = [
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

  static const List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  static String getTodayName() {
    final now = DateTime.now().weekday;
    // In Dart, weekday: 1=Monday, ..., 7=Sunday
    return weekDays[now % 7];
  }
}
