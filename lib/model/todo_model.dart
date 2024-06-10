class ToDo {
  String? id;
  String userId;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  ToDo({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  static ToDo fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
    );
  }
}
