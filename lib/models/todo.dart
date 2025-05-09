enum Priority { low, medium, high }

class Todo {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final Priority priority;
  final bool isCompleted;
  final String? imagePath;
  final String? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int order;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = Priority.medium,
    this.isCompleted = false,
    this.imagePath,
    this.categoryId,
    this.order = 0,
  })  : createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      priority: Priority.values[json['priority'] as int],
      isCompleted: json['isCompleted'] as bool,
      imagePath: json['imagePath'] as String?,
      categoryId: json['categoryId'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.index,
      'isCompleted': isCompleted,
      'imagePath': imagePath,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'order': order,
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
    String? imagePath,
    String? categoryId,
    int? order,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      imagePath: imagePath ?? this.imagePath,
      categoryId: categoryId ?? this.categoryId,
      order: order ?? this.order,
    );
  }
} 