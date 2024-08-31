class Activity {
  final String id;
  final String activity;
  final String date;
  final String icon;

  Activity({required this.id, required this.activity, required this.date, required this.icon});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      activity: json['activity'],
      date: json['date'],
      icon: json['icon'],
    );
  }
}
