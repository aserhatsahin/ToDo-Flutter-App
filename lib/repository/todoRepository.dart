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

    print("Saving tasks to SharedPreferences :   $jsonList");
  }

  Future<void> checkBoxChanged(int index) async {
    //to change checkbox
    List<Todo> todoList = await getAllData();

    todoList[index].isCompleted = !todoList[index].isCompleted;
    saveToDoList(todoList);
  }

  Future<void> addTask(String task, DateTime dueDate) async {
    if (task != '') {
      List<Todo> todoList = await getAllData();
      todoList.add(Todo(
          taskName: task, isCompleted: false, isEdit: false, dueDate: dueDate));
      print("TASK ADDED SUCCESFULLY ");
      saveToDoList(todoList);
    }
  }

  Future<void> deleteTask(int index) async {
    List<Todo> todoList = await getAllData();
    todoList.removeAt(index);

    saveToDoList(todoList);
  }

  Future<void> editTask(int index, DateTime dueDate) async {
    List<Todo> todoList = await getAllData();
    todoList[index].isEdit = true;
    todoList[index].dueDate = dueDate;
    saveToDoList(todoList);
  }

  Future<void> saveTask(String taskName, int index) async {
    List<Todo> todoList = await getAllData();
    todoList[index].taskName = taskName;
    todoList[index].isEdit = false;

    saveToDoList(todoList);
  }
}
