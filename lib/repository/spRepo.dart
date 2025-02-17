//getAll,save,add,remove
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_list_app/classes/todo.dart';
import 'package:todo_list_app/repository/todoRepository.dart';

class spRepo extends todoRepository {
  @override
  Future<List<Todo>> getAll() async {
    //get data from Shared Preferences and then puts in a todo list
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? jsonList = prefs.getStringList('todo_list');

    if (jsonList != null && jsonList.isNotEmpty) {
      List<Todo> loadedList =
          jsonList.map((json) => Todo.fromJson(jsonDecode(json))).toList();
      return loadedList;
    }
    return [];
  }

  Future<void> saveAll(List<Todo> todo) async {
    //to store into SharedPreferences
    //convert the list into JSON format and than List<String> format , than store in SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> jsonList =
        todo.map((todo) => jsonEncode(todo.toJson())).toList();
    //first make the todo list into map<String,dynamic> format and than with the jsonEncode make it a List<String>

    await prefs.setStringList('todo_list', jsonList);

    print("Saving tasks to SharedPreferences :   $jsonList");
  }

  @override
  Future<void> cbChanged(String id) async {
    //to change checkbox
    List<Todo> todoList = await getAll();
    int index = int.parse(id);
    todoList[index].isCompleted = !todoList[index].isCompleted;
    saveAll(todoList);
  }

  @override
  Future<void> add(String task, DateTime dueDate) async {
    if (task != '') {
      List<Todo> todoList = await getAll();
      todoList.add(Todo(
          taskName: task,
          isCompleted: false,
          isEdit: false,
          dueDate: dueDate,
          id: " "));
      print("TASK ADDED SUCCESFULLY ");
      saveAll(todoList);
    }
  }

  @override
  Future<void> delete(String id) async {
    List<Todo> todoList = await getAll();

    int index = int.parse(id);
    todoList.removeAt(index);

    saveAll(todoList);
  }

  Future<void> editDate(String id, DateTime dueDate) async {
    List<Todo> todoList = await getAll();
    int index = int.parse(id);
    todoList[index].isEdit = true;
    todoList[index].dueDate = dueDate;
    saveAll(todoList);
  }

  Future<void> editName(String taskName, String id) async {
    int index = int.parse(id);
    List<Todo> todoList = await getAll();
    todoList[index].taskName = taskName;
    todoList[index].isEdit = false;

    saveAll(todoList);
  }

  @override
  Stream<List<Todo>> getAllStream() {
    // TODO: implement getAllStream
    throw UnimplementedError();
  }
}
