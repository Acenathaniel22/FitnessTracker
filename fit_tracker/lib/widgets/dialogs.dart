import 'package:flutter/material.dart';
import '../utils/exercise_constants.dart';

// Helper: show a dialog to pick duration with preset buttons and custom option
Future<int?> showDurationPresetDialog(
  BuildContext context,
  int initialSeconds,
) async {
  final presets = [15, 20, 30, 45, 60, 90, 120, 180];
  return showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select Timer Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 10,
              children: [
                ...presets.map(
                  (sec) => ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(sec),
                    child: Text('${sec}s'),
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final custom = await showCustomSecondsDialog(
                      context,
                      initialSeconds,
                    );
                    if (custom != null) Navigator.of(context).pop(custom);
                  },
                  child: const Text('Custom'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

// Helper: show a dialog to pick custom seconds (10-600)
Future<int?> showCustomSecondsDialog(
  BuildContext context,
  int initialSeconds,
) async {
  int selected = initialSeconds.clamp(10, 600);
  return showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Custom Duration'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: selected > 10
                      ? () => setState(() => selected = selected - 5)
                      : null,
                ),
                Text('$selected s', style: const TextStyle(fontSize: 22)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: selected < 600
                      ? () => setState(() => selected = selected + 5)
                      : null,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(selected),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

// Helper: show dialog to add a custom exercise
Future<Map<String, dynamic>?> showAddExerciseDialog(
  BuildContext context, {
  required String bodyPart,
  required List<Map<String, dynamic>>
  existingExercises, // NEW: to check for duplicates
}) async {
  final _formKey = GlobalKey<FormState>();

  // Filter out exercises that already exist in the current day's routine
  List<String> availableExercises = bodyPartExercises[bodyPart] ?? [];
  List<String> existingExerciseLabels = existingExercises
      .map((e) => e['label'] as String)
      .toList();

  // Remove exercises that already exist (check for partial matches too)
  availableExercises = availableExercises.where((exercise) {
    // Check if this exercise name appears in any existing exercise label
    return !existingExerciseLabels.any((existing) {
      // Convert both to lowercase for better matching
      String existingLower = existing.toLowerCase();
      String exerciseLower = exercise.toLowerCase();

      // Check for exact matches or if the exercise name is contained in existing label
      return existingLower.contains(exerciseLower) ||
          exerciseLower.contains(
            existingLower.replaceAll(RegExp(r'[^a-zA-Z\s]'), '').trim(),
          );
    });
  }).toList();

  // If no exercises available, show a message
  if (availableExercises.isEmpty) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Available Exercises'),
          content: Text(
            'All ${bodyPart} exercises are already in your routine for today.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String exerciseName = availableExercises[0];
  IconData icon =
      exerciseRecommendedIcons[exerciseName] ?? customExerciseIcons[0];
  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Custom Exercise'),
        content: Form(
          key: _formKey,
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Body Part: '),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            bodyPart,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Text('Exercise: '),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButton<String>(
                            value: exerciseName,
                            isExpanded: true,
                            items: availableExercises
                                .map(
                                  (ex) => DropdownMenuItem(
                                    value: ex,
                                    child: Text(ex),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() {
                                  exerciseName = v;
                                  icon =
                                      exerciseRecommendedIcons[exerciseName] ??
                                      customExerciseIcons[0];
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Text('Icon: '),
                        const SizedBox(width: 8),
                        Icon(icon, size: 28),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop({
                'label': exerciseName,
                'icon': icon,
                'duration': 60, // default, will be set by timer
                'steps': 0,
                'calories': 0,
                'workout': 1,
                'bodyPart': bodyPart,
              });
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
