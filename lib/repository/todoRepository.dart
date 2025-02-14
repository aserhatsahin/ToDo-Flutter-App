import 'package:todo_list_app/classes/todo.dart';

abstract class todoRepository {
  Future<List<Todo>> getAll();

  Future<void> saveAll(List<Todo> todo);

  Future<void> cbChanged(int index);

  Future<void> add(String task, DateTime dueDate);

  Future<void> delete(int index);

  Future<void> editDate(int index,DateTime dueDate);

  Future<void> editName(String name, int index);
}
