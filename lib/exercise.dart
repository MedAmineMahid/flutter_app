import 'package:flutter/material.dart';

class ExercisePage extends StatelessWidget {
  final List<String> categories = [
    'Running',
    'Walking',
    'Jogging',
    'Gym',
    'Yoga',
    'HIIT',
    'CrossFit',
    'Cycling'
  ];

  final Map<String, List<Map<String, dynamic>>> exercisesByCategory = {
    'Running': [
      {
        'name': 'High Knees',
        'image': 'https://media.giphy.com/media/62aGqZoUJYtPsl0Hb0/giphy.gif',
        'description': 'Lift your knees high while running in place to improve your cardio and leg strength.'
      },
      {
        'name': 'Butt Kicks',
        'image': 'https://media.giphy.com/media/UQa44aVsUd6t7lIigt/giphy.gif',
        'description': 'Kick your heels up towards your glutes while running in place to engage your hamstrings.'
      },
      {
        'name': 'Sprint',
        'image': 'https://media.giphy.com/media/IAIJgA7BTI10YhzAeP/giphy.gif',
        'description': 'Run at maximum speed for short bursts to build explosive power and speed.'
      },
    ],
    'Walking': [
      {
        'name': 'Brisk Walking',
        'image': 'https://media.giphy.com/media/56f9TTuBozoZmNVgAW/giphy.gif',
        'description': 'Walk at a fast pace to increase your heart rate and improve cardiovascular health.'
      },
      {
        'name': 'Heel Walks',
        'image': 'https://media.giphy.com/media/G54dJB9VQQOWDwuAJX/giphy.gif',
        'description': 'Walk on your heels to strengthen your lower legs and improve balance.'
      },
    ],
    'Jogging': [
      {
        'name': 'Light Jog',
        'image': 'https://media.giphy.com/media/OlVR3S6yG8jTRbohXH/giphy.gif',
        'description': 'A gentle jog to improve endurance and stamina without overexerting yourself.'
      },
      {
        'name': 'Trail Jogging',
        'image': 'https://media.giphy.com/media/z1HH975rD1mMkBJtAe/giphy.gif',
        'description': 'Jog on uneven terrain to challenge your balance and engage different muscle groups.'
      },
    ],
    'Gym': [
      {
        'name': 'Bench Press',
        'image': 'https://media.giphy.com/media/z3HfNn64mICanASUu9/giphy.gif',
        'description': 'A strength exercise targeting the chest, shoulders, and triceps.'
      },
      {
        'name': 'Deadlift',
        'image': 'https://media.giphy.com/media/eIZXc5rF0K67nY5iPB/giphy.gif',
        'description': 'A compound movement that works the back, glutes, and legs.'
      },
      {
        'name': 'Squat',
        'image': 'https://media.giphy.com/media/2vlLAjOPXD3TccrMyp/giphy.gif',
        'description': 'An exercise that targets the thighs, hips, and buttocks.'
      },
    ],
    'Yoga': [
      {
        'name': 'Downward Dog',
        'image': 'https://media.giphy.com/media/U5hkjaoCFq3Nm/giphy.gif',
        'description': 'A pose that stretches the back, hamstrings, and calves while strengthening the shoulders.'
      },
      {
        'name': 'Tree Pose',
        'image': 'https://media.giphy.com/media/GCuN5IuzMVbIAf8U1Q/giphy.gif',
        'description': 'A balance pose that improves stability and strengthens the legs and core.'
      },
      {
        'name': 'Warrior Pose',
        'image': 'https://media.giphy.com/media/RJDR9OIKxcnEgeKtDs/giphy.gif',
        'description': 'A powerful pose that enhances strength, balance, and stamina.'
      },
    ],
    'HIIT': [
      {
        'name': 'Burpees',
        'image': 'https://media.giphy.com/media/l41YgS3UPP5Qjwr8Q/giphy.gif',
        'description': 'A full-body exercise combining squats, jumps, and push-ups for a high-intensity workout.'
      },
      {
        'name': 'Mountain Climbers',
        'image': 'https://media.giphy.com/media/bWYc47O3jSef6/giphy.gif',
        'description': 'A cardio move that mimics climbing, improving agility and core strength.'
      },
      {
        'name': 'Jump Squats',
        'image': 'https://media.giphy.com/media/nmuUOAEvrKTLDT3yTn/giphy.gif',
        'description': 'A plyometric exercise that combines squats and jumps to build lower body strength and power.'
      },
    ],
    'CrossFit': [
      {
        'name': 'Kettlebell Swing',
        'image': 'https://media.giphy.com/media/3oEjHHYOTZeHjzLLOg/giphy.gif',
        'description': 'A dynamic movement that targets the hips, glutes, and core.'
      },
      {
        'name': 'Box Jump',
        'image': 'https://media.giphy.com/media/xT0GqBz4Z1a2tvQCWI/giphy.gif',
        'description': 'A plyometric exercise that improves explosive power and coordination.'
      },
      {
        'name': 'Jump Rope',
        'image': 'https://media.giphy.com/media/13mpq8Az1u5dTy/giphy.gif',
        'description': 'A cardio exercise that enhances agility and endurance.'
      },
    ],
    'Cycling': [
      {
        'name': 'Indoor Cycling',
        'image': 'https://media.giphy.com/media/dPByMm4KCIWvLKbUIz/giphy.gif',
        'description': 'A high-intensity workout performed on a stationary bike to improve cardiovascular fitness.'
      },
      {
        'name': 'Spinning',
        'image': 'https://media.giphy.com/media/DLJyXzfIng6SLGBggu/giphy.gif',
        'description': 'A vigorous cycling workout that simulates various terrains and intensities.'
      },
      {
        'name': 'Long Distance Cycling',
        'image': 'https://media.giphy.com/media/2Ixw6VJ64gUKcXXeLe/giphy.gif',
        'description': 'Endurance cycling over long distances to build stamina and leg strength.'
      },
    ],
  };

  void _showExercises(BuildContext context, String category) {
    final exercises = exercisesByCategory[category] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$category Exercises', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: exercises.map((exercise) {
                final imageUrl = exercise['image'] ?? '';
                final description = exercise['description'] ?? 'No description available';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise['name'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        if (imageUrl.isNotEmpty)
                          Image.network(
                            imageUrl,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, color: Colors.red);
                            },
                          )
                        else
                          Text('No image available'),
                        SizedBox(height: 8),
                        Text(description, style: TextStyle(fontSize: 14)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Page'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          IconData iconData;

          switch (categories[index]) {
            case 'Running':
              iconData = Icons.run_circle;
              break;
            case 'Walking':
              iconData = Icons.directions_walk;
              break;
            case 'Jogging':
              iconData = Icons.run_circle;
              break;
            case 'Gym':
              iconData = Icons.fitness_center;
              break;
            case 'Yoga':
              iconData = Icons.self_improvement;
              break;
            case 'HIIT':
              iconData = Icons.accessibility_new;
              break;
            case 'CrossFit':
              iconData = Icons.fitness_center;
              break;
            case 'Cycling':
              iconData = Icons.directions_bike;
              break;
            default:
              iconData = Icons.help;
          }

          return ListTile(
            leading: Icon(iconData, color: Colors.blue),
            title: Text(categories[index]),
            onTap: () => _showExercises(context, categories[index]),
          );
        },
      ),
    );
  }
}
