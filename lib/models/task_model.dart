class Task {
  int id;
  String title;
  DateTime time;
  DateTime date;
  String priority;
  int status;
  bool isActive;

  Task({this.title, this.date, this.time,this.priority, this.status,this.isActive});
  Task.withId({this.id, this.title, this.date, this.time, this.priority, this.status,this.isActive});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['time'] = time.toString();
    map['priority'] = priority;
    map['status'] = status;
    map['isActive'] = isActive ? 0 : 1;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map['id'],
        title: map['title'],
        date: DateTime.parse(map['date']),
        time: DateTime.parse(map['time']),
        priority: map['priority'],
        status: map['status'],
        isActive: map['isActive'] == 0,);
  }
}
