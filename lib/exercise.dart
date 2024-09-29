import 'package:flutter/material.dart';
import 'api_service.dart';

class ExercisePage extends StatelessWidget {
  final List<String> bodyParts = [
    'back', 'cardio', 'chest', 'lower arms', 'lower legs',
    'neck', 'shoulders', 'upper arms', 'upper legs', 'waist'
  ];

  final String proxyUrlPrefix = 'https://cors-anywhere.herokuapp.com/';

  void _showExercises(BuildContext context, String bodyPart) async {
    try {
      final exercises = await ApiService.fetchExercisesByBodyPart(bodyPart);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$bodyPart Exercises', style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures cards fill the width
                children: exercises.map<Widget>((exercise) {
                  final imageUrl = exercise['gifUrl'] ?? '';
                  final description = exercise['instructions']?.join('\n') ?? 'No description available';
                  final proxiedImageUrl = imageUrl.isNotEmpty ? '$proxyUrlPrefix$imageUrl' : '';

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners for better style
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0), // Adjust padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            exercise['name'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          if (proxiedImageUrl.isNotEmpty)
                            Container(
                              height: 500, // Increased height for better display
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8), // Rounded corners for the image
                                image: DecorationImage(
                                  image: NetworkImage(proxiedImageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else
                            Text('No image available'),
                          SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(fontSize: 14),
                          ),
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
    } catch (e) {
      print('Error fetching exercises: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Page'),
      ),
      body: ListView.builder(
        itemCount: bodyParts.length,
        itemBuilder: (context, index) {
          IconData iconData = Icons.fitness_center; // Default icon

          switch (bodyParts[index]) {
            case 'back':
              iconData = Icons.fitness_center;
              break;
            case 'cardio':
              iconData = Icons.directions_run;
              break;
            case 'chest':
              iconData = Icons.fitness_center;
              break;
            case 'lower arms':
              iconData = Icons.fitness_center;
              break;
            case 'lower legs':
              iconData = Icons.directions_walk;
              break;
            case 'neck':
              iconData = Icons.fitness_center;
              break;
            case 'shoulders':
              iconData = Icons.fitness_center;
              break;
            case 'upper arms':
              iconData = Icons.fitness_center;
              break;
            case 'upper legs':
              iconData = Icons.directions_walk;
              break;
            case 'waist':
              iconData = Icons.fitness_center;
              break;
          }

          return ListTile(
            leading: Icon(iconData, color: Colors.blue),
            title: Text(bodyParts[index]),
            onTap: () => _showExercises(context, bodyParts[index]),
          );
        },
      ),
    );
  }
}
