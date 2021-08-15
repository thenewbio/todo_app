class Note {
  int id;
  final String title;
  final String content;
  final DateTime dateCreated;
 

  Note({
    this.id,
    this.title,
    this.content,
    this.dateCreated,
   
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateCreated': dateCreated.toIso8601String(),
   
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateCreated: DateTime.parse(map['dateCreated'] as String),

    );
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, dateCreated: $dateCreated,)';
  }
}
