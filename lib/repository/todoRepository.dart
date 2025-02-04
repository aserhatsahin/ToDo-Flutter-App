//getAll,save,add,remove
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_list_app/classes/todo.dart';

class TodoRepository {
  Future<List<Todo>> getAllData() async {
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

  Future<void> saveToDoList(List<Todo> todo) async {
    //to store into SharedPreferences
    //convert the list into JSON format and than List<String> format , than store in SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> jsonList =
        todo.map((todo) => jsonEncode(todo.toJson())).toList();
//first make the todo list into map<String,dynamic> format and than with the jsonEncode make it a List<String>

    await prefs.setStringList('todo_list', jsonList);
  }

  Future<void> checkBoxChanged(int index, List<Todo> todo) async {
    //to change checkbox
    todo[index].isCompleted = !todo[index].isCompleted;
    saveToDoList(todo);
  }

  Future<void> addTask(String task, List<Todo> todo, DateTime dueDate) async {
    if (task != '') {
      todo.add(Todo(
          taskName: task, isCompleted: false, isEdit: false, dueDate: dueDate));

      saveToDoList(todo);
    }
  }

  Future<void> deleteTask(int index, List<Todo> todo) async {
    todo.removeAt(index);

    saveToDoList(todo);
  }

  Future<void> editTask(int index, List<Todo> todo, DateTime dueDate) async {
    todo[index].isEdit = true;
    todo[index].dueDate = dueDate;
    saveToDoList(todo);
  }

  Future<void> saveTask(String taskName, int index, List<Todo> todo) async {
    todo[index].taskName = taskName;
    todo[index].isEdit = false;

    saveToDoList(todo);
  }



}
