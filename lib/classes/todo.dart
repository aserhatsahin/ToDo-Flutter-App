class Todo {
  String taskName;
  bool isCompleted;
  bool isEdit;
  DateTime dueDate;

  Todo(
      {required this.taskName,
      this.isCompleted = false,
      this.isEdit = false,
      required this.dueDate});

  @override
  String toString() {
    return 'Todo(taskName: $taskName, isCompleted: $isCompleted, dueDate: $dueDate)';
  }

  Map<String, dynamic> toJson() => {
        'taskName': taskName,
        'isCompleted': isCompleted,
        'isEdit': isEdit,
        'dueDate': dueDate.toIso8601String()
      };

  Todo.fromJson(Map<String, dynamic> json)
      : taskName = json['taskName'] as String,
        isCompleted = json['isCompleted'] as bool,
        isEdit = json['isEdit'] as bool,
        dueDate = DateTime.parse(json['dueDate']);
}
