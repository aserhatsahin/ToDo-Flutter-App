import 'dart:async';
import 'dart:core';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:todo_list_app/repository/todoRepository.dart';
import 'package:todo_list_app/utils/todo_list.dart';
import 'package:todo_list_app/classes/todo.dart';

//NULL SAFETY , FUTUREBUILDER
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _controller = TextEditingController();
  final TodoRepository todoRepo = TodoRepository();
  final StreamController<List<Todo>> _taskController =
      StreamController.broadcast();

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
    loadData();
  }

  @override
  void dispose() {
    _taskController.close();
    super.dispose();
  }

  void loadData() async {
    List<Todo> loadedTodos = await todoRepo.getAllData();
    _taskController.sink.add(loadedTodos);
  }

  List<Todo> createFilteredList(List<String> selTags, List<Todo> snapshotList) {
    final now = DateTime.now();
    filteredTodoList.clear();
    for (int i = 0; i < snapshotList.length; i++) {
      Todo currentTask = snapshotList[i];

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

  void checkBoxChanged(int index) {
    todoRepo.checkBoxChanged(index);
    ;
    loadData();
  }

  void saveNewTask() async {
    if (_controller.text.isNotEmpty) {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2024, 3, 18),
        lastDate: DateTime(2030, 3, 18),
      );

      if (pickedDate != null) {
        await todoRepo.addTask(_controller.text, pickedDate);
        loadData();

        _controller.clear();
      }
    }
  }

  void deleteTask(int index) async {
    await todoRepo.deleteTask(index);
    loadData();
  }

  void editTask(int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2024, 3, 18),
      lastDate: DateTime(2030, 3, 18),
    );

    if (pickedDate != null) {
      await todoRepo.editTask(index, pickedDate);
    }
    loadData();
  }

  void saveTask(String taskName, int index) async {
    await todoRepo.saveTask(taskName, index);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFCFCD),
      appBar: AppBar(
        toolbarHeight: 50,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(80, 20, 50, 20),
              child: Text(
                'Simple Todo',
                style: TextStyle(
                    color: Color(0xFFD7DEDC),
                    fontSize: 20,
                    height: 0.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromARGB(124, 122, 59, 105),
            icon: Icon(Icons.filter_alt_outlined),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  enabled: false,
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 6.0,
                    children: _filterTags.map((tag) {
                      return FilterChip(
                        label: Text(tag),
                        selected: _selectedTags.contains(tag),
                        onSelected: (isSelected) {
                          _toggleTag(tag);
                          Navigator.pop(context); // Popup'u kapatır
                        },
                        backgroundColor:
                            const Color.fromARGB(255, 217, 207, 222),
                        selectedColor: const Color(0xFF7A3B69),
                      );
                    }).toList(),
                  ),
                ),
              ];
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Color(0xFF7A3B69),
        foregroundColor: Color(0xFFD7DEDC),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(3, 0, 3, 10),
            child: DatePicker(
              width: 100,
              height: 100,
              DateTime.now().subtract(Duration(days: 7)),
              activeDates: List.generate(
                  38,
                  (index) => (DateTime.now().subtract(Duration(days: 7)))
                      .add(Duration(days: index))),
              initialSelectedDate: DateTime.now(),
              selectionColor: const Color(0xFF7A3B69),
              selectedTextColor: Color(0xFFD7DEDC),
              daysCount: 38,
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Todo>>(
              stream: _taskController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  filteredTodoList =
                      createFilteredList(_selectedTags, snapshot.data!);

                  if (filteredTodoList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              'There are no tasks match the selected filters.',
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: const Color(0xFF9A879D),
                              ),
                            ),
                          ],
                          totalRepeatCount: 5,
                          pause: const Duration(milliseconds: 1000),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredTodoList.length,
                    itemBuilder: (BuildContext context, index) {
                      final Todo task = filteredTodoList[index];
                      final int originalIndex = snapshot.data!.indexOf(task);

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
                  );
                } else {
                  return Center(child: Text("Unexpected error occurred."));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Add new to-do items',
                    filled: true,
                    fillColor: const Color.fromARGB(146, 188, 161, 192),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF7A3B69)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF7A3B69)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              child: FloatingActionButton(
                onPressed: saveNewTask,
                elevation: 0,
                backgroundColor: Color(0xFF7A3B69),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFFD7DEDC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
