class Task {
  int id;
  final String title;
  final String content;
  final String category;
  final DateTime dateCreated;
  final DateTime scheduledDate;
  final String scheduledTime;
  final bool isImportant;
  bool isActive;

  Task({
    this.id,
    this.title,
    this.content,
    this.category,
    this.dateCreated,
    this.scheduledDate,
    this.scheduledTime,
    this.isActive,
    this.isImportant,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'dateCreated': dateCreated.toIso8601String(),
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': scheduledTime,
      'isActive': isActive ? 0 : 1,
      'isImportant': isImportant ? 0 : 1,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      dateCreated:  DateTime.parse(map['dateCreated'] as String),
      scheduledDate: map['scheduledDate'] == null ? null: DateTime.parse(map['scheduledDate'] as String),
      scheduledTime: map['scheduledTime'],
      isActive: map['isActive'] == 0,
      isImportant: map['isImportant'] == 0,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, content: $content, category: $category, dateCreated: $dateCreated, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, isActive: $isActive, isImportant: $isImportant)';
  }
}
