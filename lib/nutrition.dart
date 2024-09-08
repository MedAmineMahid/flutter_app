import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tested/api_service.dart';
import 'Meals.dart'; // Import Meal class
class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _mealNameController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _selectedIngredients = [];
  int _totalCalories = 0;

  void _searchFood(String query) async {
    if (query.isNotEmpty) {
      try {
        final response = await ApiService.searchFood(query);
        final results = jsonDecode(response.body); // Decode the response
        final foods = results['common'] as List<dynamic>? ?? [];
        setState(() {
          _searchResults = foods.map((food) => {
            'item_name': food['food_name'],
          }).toList();
        });
      } catch (e) {
        print('Error fetching search results: $e');
        setState(() {
          _searchResults = [];
        });
      }
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _selectFoodItem(String foodName) async {
    try {
      final response = await ApiService.getFoodCalories(foodName);
      final results = jsonDecode(response.body); // Parse the response body
      final foods = results['foods'] as List<dynamic>? ?? [];

      if (foods.isNotEmpty) {
        final foodItem = foods[0] as Map<String, dynamic>;
        final calories = foodItem['nf_calories'] as double?;
        if (calories != null) {
          setState(() {
            _selectedIngredients.add(
              '$foodName - ${calories.toInt()} calories',
            );
            _totalCalories += calories.toInt();
            _foodController.clear();
            _searchResults = [];
          });
        } else {
          print('Selected item does not have calories');
        }
      } else {
        print('No nutritional information found for the food: $foodName');
      }
    } catch (e) {
      print('Error fetching nutritional info: $e');
    }
  }

  void _removeIngredient(int index) {
    final ingredient = _selectedIngredients[index];
    final calories = int.tryParse(ingredient.split('-').last.trim().split(' ')[0]) ?? 0;
    setState(() {
      _totalCalories -= calories;
      _selectedIngredients.removeAt(index);
    });
  }

  void _saveMeal() async {
    final mealName = _mealNameController.text;
    if (mealName.isNotEmpty) {
      final mealData = {
        'mealName': mealName,
        'ingredients': _selectedIngredients,
        'totalCalories': _totalCalories,
      };
      try {
        final response = await ApiService.saveMeal(mealData);
        if (response.statusCode == 201) {
          _mealNameController.clear();
          setState(() {
            _selectedIngredients = [];
            _totalCalories = 0;
          });
        } else {
          print('Error saving meal: ${response.body}');
        }
      } catch (e) {
        print('Error saving meal: $e');
      }
    } else {
      print('Meal name cannot be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Nutrition Calculator'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _foodController,
              onChanged: _searchFood,
              decoration: InputDecoration(
                labelText: 'Enter food name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 16),
            if (_searchResults.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final foodItem = _searchResults[index];
                    return ListTile(
                      title: Text(
                        foodItem['item_name'],
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => _selectFoodItem(foodItem['item_name']),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 16),
            Text(
              'Selected Ingredients:',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedIngredients.length,
                itemBuilder: (context, index) {
                  final ingredient = _selectedIngredients[index];
                  return ListTile(
                    title: Text(
                      ingredient,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeIngredient(index),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Total Calories: $_totalCalories',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _mealNameController,
              decoration: InputDecoration(
                labelText: 'Meal Name',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveMeal,
              child: Text('Save Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
