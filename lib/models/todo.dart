enum Priority { low, medium, high }

class Todo {
  final String id;
  String title;
  String? description;
  bool isCompleted;
  DateTime? dueDate;
  Priority priority;
  String? imagePath;
  DateTime createdAt;
  DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    this.priority = Priority.medium,
    this.imagePath,
  })  : createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Todo copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    Priority? priority,
    String? imagePath,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.toString(),
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      priority: Priority.values.firstWhere(
        (e) => e.toString() == json['priority'],
        orElse: () => Priority.medium,
      ),
      imagePath: json['imagePath'],
    );
  }
} 