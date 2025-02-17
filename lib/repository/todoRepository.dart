
import 'package:todo_list_app/classes/todo.dart';

abstract class todoRepository {
 Future<List<Todo>> getAll();
Stream<List<Todo>> getAllStream();
  Future<void> cbChanged(String docId);

  Future<void> add(String task, DateTime dueDate);

  Future<void> delete(String docId);

  Future<void> editDate(String docId, DateTime dueDate);

  Future<void> editName(String name, String docId);
}
