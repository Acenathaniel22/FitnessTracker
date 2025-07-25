import 'package:flutter/material.dart';

// Icon choices for custom exercises
const List<IconData> customExerciseIcons = [
  Icons.fitness_center,
  Icons.directions_run,
  Icons.directions_walk,
  Icons.sports_kabaddi,
  Icons.accessibility,
  Icons.spa,
  Icons.cable,
  Icons.timer,
];

// Body part choices for custom exercises
const List<String> customBodyParts = [
  'Back',
  'Chest',
  'Legs',
  'Arms',
  'Shoulders',
  'Cardio',
  'Core',
  'Full Body',
  'Other',
];

// Map of body part to exercise names
const Map<String, List<String>> bodyPartExercises = {
  'Back': [
    'Pull-ups',
    'Barbell Rows',
    'Deadlifts',
    'Lat Pulldown',
    'Seated Row',
  ],
  'Chest': ['Bench Press', 'Chest Fly', 'Pushups', 'Incline Press'],
  'Legs': ['Squats', 'Lunges', 'Leg Curls', 'Leg Press', 'Calf Raises'],
  'Arms': ['Tricep Dips', 'Bicep Curls', 'Tricep Pushdowns', 'Hammer Curls'],
  'Shoulders': ['Shoulder Press', 'Lateral Raises', 'Front Raises', 'Shrugs'],
  'Cardio': ['Treadmill', 'Cycling', 'Jump Rope', 'Rowing'],
  'Core': ['Planks', 'Crunches', 'Russian Twists', 'Leg Raises'],
  'Full Body': ['Burpees', 'Mountain Climbers', 'Jumping Jacks'],
  'Other': ['Custom Move'],
};

// Map of exercise name to recommended icon
const Map<String, IconData> exerciseRecommendedIcons = {
  // Back
  'Pull-ups': Icons.fitness_center,
  'Barbell Rows': Icons.cable,
  'Deadlifts': Icons.sports_kabaddi,
  'Lat Pulldown': Icons.cable,
  'Seated Row': Icons.cable,
  // Chest
  'Bench Press': Icons.fitness_center,
  'Chest Fly': Icons.fitness_center,
  'Pushups': Icons.accessibility,
  'Incline Press': Icons.fitness_center,
  // Legs
  'Squats': Icons.directions_run,
  'Lunges': Icons.directions_walk,
  'Leg Curls': Icons.directions_walk,
  'Leg Press': Icons.directions_run,
  'Calf Raises': Icons.directions_walk,
  // Arms
  'Tricep Dips': Icons.accessibility,
  'Bicep Curls': Icons.fitness_center,
  'Tricep Pushdowns': Icons.cable,
  'Hammer Curls': Icons.fitness_center,
  // Shoulders
  'Shoulder Press': Icons.fitness_center,
  'Lateral Raises': Icons.fitness_center,
  'Front Raises': Icons.fitness_center,
  'Shrugs': Icons.fitness_center,
  // Cardio
  'Treadmill': Icons.directions_run,
  'Cycling': Icons.directions_bike,
  'Jump Rope': Icons.directions_run,
  'Rowing': Icons.directions_boat,
  // Core
  'Planks': Icons.accessibility,
  'Crunches': Icons.accessibility,
  'Russian Twists': Icons.accessibility,
  'Leg Raises': Icons.directions_walk,
  // Full Body
  'Burpees': Icons.accessibility,
  'Mountain Climbers': Icons.directions_run,
  'Jumping Jacks': Icons.accessibility,
  // Other
  'Custom Move': Icons.timer,
};
