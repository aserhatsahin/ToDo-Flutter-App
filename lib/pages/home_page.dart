import 'dart:core';

import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:todo_list_app/repository/todoRepository.dart';
import 'package:todo_list_app/utils/todo_list.dart';
import 'package:todo_list_app/classes/todo.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _controller = TextEditingController();
  final TodoRepository todoRepo = TodoRepository();

  List<Todo> todo = [
    Todo(
        taskName: 'Learn Flutter',
        isCompleted: false,
        isEdit: false,
        dueDate: DateTime(2025, 4, 24)),
    Todo(
        taskName: 'Drink Coffee',
        isCompleted: false,
        isEdit: false,
        dueDate: DateTime(2025, 4, 23)),
  ];

  final List<String> _filterTags = [
    'Due',
    'Not Due',
    'Completed',
    'Incompleted'
  ];

  List<Todo> filteredTodoList = [];

  final List<String> _selectedTags = [];

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      loadData();
    });
  }

  List<Todo> createFilteredList(List<String> selTags) {
    final now = DateTime.now();
    filteredTodoList.clear();
    for (int i = 0; i < todo.length; i++) {
      Todo currentTask = todo[i];

      bool isDateMatch = currentTask.dueDate.year == _selectedDate.year &&
          currentTask.dueDate.month == _selectedDate.month &&
          currentTask.dueDate.day == _selectedDate.day;

      if (isDateMatch &&
          ((selTags.contains('Completed') && currentTask.isCompleted) ||
              (selTags.contains('Incompleted') && !currentTask.isCompleted) ||
              (selTags.contains('Due') && currentTask.dueDate.isBefore(now)) ||
              (selTags.contains('Not Due') &&
                  currentTask.dueDate.isAfter(now)) ||
              selTags.isEmpty)) {
        if (!filteredTodoList.contains(currentTask)) {
          filteredTodoList.add(currentTask);
        }
      }
    }

    return filteredTodoList;
  }

  void loadData() async {
    List<Todo> loadedList = await todoRepo.getAllData();
    setState(() {
      todo = loadedList;
    });
  }

  void checkBoxChanged(int index) {
    todoRepo.checkBoxChanged(index, todo);
    setState(() {});
  }

  void saveNewTask() async {
    if (_controller.text.isNotEmpty) {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2024, 3, 18),
        lastDate: DateTime(2030, 3, 18),
      );

      if (pickedDate != null) {
        await todoRepo.addTask(_controller.text, todo, pickedDate);
        loadData();
        setState(() {});
        _controller.clear();
      }
    }
  }

  void deleteTask(int index) async {
    await todoRepo.deleteTask(index, todo);
    setState(() {});
  }

  void editTask(int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2024, 3, 18),
      lastDate: DateTime(2030, 3, 18),
    );

    if (pickedDate != null) {
      await todoRepo.editTask(index, todo, pickedDate);
      setState(() {});
    }
  }

  void saveTask(String taskName, int index) async {
    await todoRepo.saveTask(taskName, index, todo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredTodoList = createFilteredList(_selectedTags);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 146, 221, 202),
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(25, 20, 0, 10),
              child: Text(
                'Simple Todo',
                style: TextStyle(
                    fontSize: 14, height: 0.5, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: DatePicker(
                width: 70,
                height: 80,
                DateTime.now().subtract(Duration(days: 7)),
                activeDates: List.generate(
                    38,
                    (index) => (DateTime.now().subtract(Duration(days: 7)))
                        .add(Duration(days: index))),
                initialSelectedDate: DateTime.now(),
                selectionColor: const Color.fromARGB(255, 77, 163, 143),
                selectedTextColor: Colors.white,
                daysCount: 38,
                onDateChange: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        leading: Builder(builder: (BuildContext context) {
          return Container(
            alignment: Alignment.centerLeft,
            height: 30,
            width: 30,
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.filter_list),
            ),
          );
        }),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(255, 141, 227, 218),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: DrawerHeader(
                  child: Center(
                    child: Text(
                      'Filter Options',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _filterTags.map((tag) {
                    return SizedBox(
                      width: 120,
                      child: FilterChip(
                        label: Center(child: Text(tag)),
                        selected: _selectedTags.contains(tag),
                        onSelected: (isSelected) {
                          _toggleTag(tag);
                          setState(() {});
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.teal[200],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: filteredTodoList.isEmpty
          ? Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(
                'There are no tasks that matches the selected filters !!!',
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              )
            ])
          : ListView.builder(
              itemCount: filteredTodoList.isEmpty
                  ? todo.length
                  : filteredTodoList.length,
              itemBuilder: (BuildContext context, index) {
                final Todo task = filteredTodoList[index];
                final int originalIndex = todo.indexOf(
                    task); // dogru liste uzerinde crud islemlerini yapabilmek icin

                return ToDoList(
                  taskName: task.taskName,
                  taskCompleted: task.isCompleted,
                  taskEdit: task.isEdit,
                  dueDate: task.dueDate,
                  onChanged: (value) => checkBoxChanged(originalIndex),
                  deleteFunction: (context) => deleteTask(originalIndex),
                  editFunction: (context) => editTask(originalIndex),
                  saveFunction: (newTaskName) =>
                      saveTask(newTaskName, originalIndex),
                  editController: TextEditingController(),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Add new to-do items',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 174, 235, 229),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 43, 129, 120)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: saveNewTask,
              backgroundColor: Colors.teal.shade800,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
