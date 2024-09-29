import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'api_service.dart';
import 'Meals.dart';

class TrackerPage extends StatefulWidget {
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  List<Meal> _meals = [];
  List<Map<String, dynamic>> _activities = [];
  Map<String, List<dynamic>> _itemsByDate = {};
  Map<String, Map<String, double>> _caloriesData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final userId = await ApiService.fetchSignedInUserId();
    if (userId != null) {
      try {
        // Fetch meals and activities
        final meals = await ApiService.fetchUserMeals(userId);
        final activities = await ApiService.fetchUserActivities(userId);

        // Combine meals and activities by date
        _groupItemsByDate(meals, activities);
        _calculateCaloriesData(meals, activities);

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error loading data: $e');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print('User ID is null');
    }
  }

  void _groupItemsByDate(List<Meal> meals, List<Map<String, dynamic>> activities) {
    final Map<String, List<dynamic>> itemsByDate = {};

    // Group meals by date
    for (var meal in meals) {
      if (meal.time != null) {
        final String date = DateFormat('yyyy-MM-dd').format(meal.time!);
        itemsByDate.putIfAbsent(date, () => []).add(meal);
      }
    }

    // Group activities by date
    for (var activity in activities) {
      final String date = activity['time']; // Assuming the time is in 'yyyy-MM-dd' format
      itemsByDate.putIfAbsent(date, () => []).add(activity);
    }

    setState(() {
      _itemsByDate = itemsByDate;
    });
  }

  void _calculateCaloriesData(List<Meal> meals, List<Map<String, dynamic>> activities) {
    final Map<String, double> consumedCaloriesData = {};
    final Map<String, double> burnedCaloriesData = {};

    // Calculate total calories consumed
    for (var meal in meals) {
      if (meal.time != null) {
        final String date = DateFormat('yyyy-MM-dd').format(meal.time!);
        consumedCaloriesData[date] = (consumedCaloriesData[date] ?? 0) + (meal.totalCalories?.toDouble() ?? 0);
      }
    }

    for (var activity in activities) {
      final String date = activity['time'];
      burnedCaloriesData[date] = (burnedCaloriesData[date] ?? 0) + (activity['caloriesBurned']?.toDouble() ?? 0);
    }

    setState(() {
      _caloriesData = {
        'consumed': consumedCaloriesData,
        'burned': burnedCaloriesData,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Tracker Page'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _itemsByDate.isEmpty
              ? Center(
                  child: Text(
                    'No meals or activities found.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView(
                  children: [
                    ..._itemsByDate.entries.map((entry) {
                      final date = entry.key;
                      final items = entry.value;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd').format(DateTime.parse(date)),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Add Pie Chart for each date
                            _buildCaloriesPieChart(date),
                            SizedBox(height: 10),
                            ...items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Card(
                                color: Colors.grey[850],
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: _buildItem(item),
                                ),
                              ),
                            )).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
    );
  }

  Widget _buildItem(dynamic item) {
    if (item is Meal) {
      return ListTile(
        title: Text(
          item.mealName ?? 'No meal name',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(item.time!)}',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              'Ingredients: ${item.ingredients?.join(', ') ?? 'No ingredients'}',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              'Total Calories: ${item.totalCalories ?? 'N/A'}',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    } else if (item is Map<String, dynamic>) {
      return ListTile(
        title: Text(
          item['title'] ?? 'No title',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Duration: ${item['duration'] ?? 'No duration'} minutes',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              'Calories Burned: ${item['caloriesBurned'] ?? 'N/A'}',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink(); 
    }
  }

  Widget _buildCaloriesPieChart(String date) {
    final double consumed = _caloriesData['consumed']?[date] ?? 0;
    final double burned = _caloriesData['burned']?[date] ?? 0;

    List<PieChartSectionData> sections = [
      PieChartSectionData(
        value: consumed,
        color: Colors.blue,
        title: 'Consumed',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 14),
      ),
      PieChartSectionData(
        value: burned,
        color: Colors.red,
        title: 'Burned',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 14),
      ),
    ];

    return Container(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
          borderData: FlBorderData(show: false),
          pieTouchData: PieTouchData(enabled: false),
        ),
      ),
    );
  }
}
