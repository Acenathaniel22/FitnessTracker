import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const GymDashboardApp());
}

class GymDashboardApp extends StatelessWidget {
  const GymDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Routine Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
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
      home: const GymDashboard(),
    );
  }
}

class GymDashboard extends StatefulWidget {
  const GymDashboard({super.key});

  @override
  State<GymDashboard> createState() => _GymDashboardState();
}

class _GymDashboardState extends State<GymDashboard> {
  bool started = false;
  String selectedDay = _getTodayName();

  static String _getTodayName() {
    final now = DateTime.now().weekday;
    return [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ][now - 1];
  }

  final Map<String, List<Map<String, dynamic>>> weeklyRoutine = const {
    'Monday': [
      {'label': "Warm-up: 10 min treadmill", 'icon': Icons.directions_run},
      {'label': "Bench Press - 4 Sets", 'icon': Icons.fitness_center},
      {'label': "Tricep Pushdowns - 3 Sets", 'icon': Icons.cable},
    ],
    'Tuesday': [
      {'label': "Pull-ups - 3 Sets", 'icon': Icons.fitness_center},
      {'label': "Deadlifts - 4 Sets", 'icon': Icons.sports_kabaddi},
      {'label': "Barbell Rows - 3 Sets", 'icon': Icons.cable},
    ],
    'Wednesday': [
      {'label': "Squats - 4 Sets", 'icon': Icons.directions_run},
      {'label': "Lunges - 3 Sets", 'icon': Icons.directions_walk},
      {'label': "Leg Curls - 3 Sets", 'icon': Icons.fitness_center},
    ],
    'Thursday': [
      {'label': "Shoulder Press - 4 Sets", 'icon': Icons.fitness_center},
      {'label': "Lateral Raises - 3 Sets", 'icon': Icons.trending_up},
      {'label': "Front Raises - 3 Sets", 'icon': Icons.trending_up},
    ],
    'Friday': [
      {'label': "Chest Fly - 4 Sets", 'icon': Icons.sports_mma},
      {'label': "Pushups - 3 Sets", 'icon': Icons.accessibility},
      {'label': "Tricep Dips - 3 Sets", 'icon': Icons.accessibility},
    ],
    'Saturday': [
      {'label': "Cardio: 20 min", 'icon': Icons.directions_run},
      {'label': "Abs Workout - 3 Sets", 'icon': Icons.fitness_center},
      {'label': "Planks - 3 Sets", 'icon': Icons.accessibility},
    ],
    'Sunday': [
      {'label': "Rest & Recovery", 'icon': Icons.spa},
      {'label': "Stretching", 'icon': Icons.self_improvement},
      {'label': "Sauna", 'icon': Icons.hot_tub},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final routine = weeklyRoutine[selectedDay] ?? [];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B1B1B), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: started
            ? ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppBar(
              title: Text(
                'DAILY GYM ROUTINE',
                style: GoogleFonts.robotoCondensed(
                  color: const Color(0xFFFF2D2D),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Day:",
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                DropdownButton<String>(
                  dropdownColor: const Color(0xFF2D2D2D),
                  value: selectedDay,
                  iconEnabledColor: const Color(0xFFFF2D2D),
                  style: const TextStyle(color: Colors.white),
                  underline: Container(
                    height: 2,
                    color: const Color(0xFFFF2D2D),
                  ),
                  items: weeklyRoutine.keys.map((day) {
                    return DropdownMenuItem<String>(
                      value: day,
                      child: Text(day, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newDay) {
                    setState(() {
                      selectedDay = newDay!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "$selectedDay Routine",
              style: GoogleFonts.robotoCondensed(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF2D2D),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            ...routine.map((exercise) {
              return RoutineTile(
                label: exercise['label'],
                icon: exercise['icon'],
              );
            }),
            const SizedBox(height: 30),
            Text(
              "Fitness Tracker",
              style: GoogleFonts.robotoCondensed(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF2D2D),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                FitnessStatCard(label: "Steps", value: "8,420", icon: Icons.directions_walk),
                FitnessStatCard(label: "Calories", value: "560 kcal", icon: Icons.local_fire_department),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                FitnessStatCard(label: "Water", value: "2.0 L", icon: Icons.water_drop),
                FitnessStatCard(label: "Workout", value: "1h 15m", icon: Icons.timer),
              ],
            ),
          ],
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fitness_center, color: Colors.redAccent, size: 100),
              const SizedBox(height: 20),
              Text(
                "Ready to Crush It?",
                style: GoogleFonts.bebasNeue(
                  fontSize: 36,
                  color: Colors.white,
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
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
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
    );
  }
}

class RoutineTile extends StatelessWidget {
  final String label;
  final IconData icon;

  const RoutineTile({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF2D2D), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.robotoCondensed(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FitnessStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const FitnessStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFF2D2D), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.robotoCondensed(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.robotoCondensed(
                color: const Color(0xFFFF2D2D),
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
