class Todo {
  int? id;
  String title;
  String description;
  bool completed;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['_id'],
      title: map['title'],
      description: map['description'],
      completed: map['completed'] == 1,
    );
  }
}
