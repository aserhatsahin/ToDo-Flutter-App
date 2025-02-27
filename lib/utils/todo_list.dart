import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoList extends StatelessWidget {
  ToDoList({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.taskEdit,
    required this.dueDate,
    required this.editController,
    required this.onChanged,
    required this.deleteFunction,
    required this.editFunction,
    required this.saveFunction,
  });

//final _formKey=GlobalKey<FormState>();
  final String taskName;
  final bool taskCompleted;
  final bool taskEdit;
  final DateTime dueDate;
  final TextEditingController editController;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? editFunction;
  final Function(String)? saveFunction;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: deleteFunction,
                icon: Icons.delete,
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Color(0xFF563440),
              ),
              SlidableAction(
                onPressed: editFunction,
                icon: Icons.edit,
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Color(0xFF7A3B69),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF9A879D),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: taskCompleted,
                  onChanged: onChanged,
                  activeColor: const Color(0xFF563440),
                  checkColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                taskEdit
                    ? Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'DON\'T leave the task empty !!!!';
                                  }
                                },
                                controller: editController,
                                autofocus: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF7A3B69)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: 'Edit task',
                                  hintStyle:
                                      const TextStyle(color: Colors.white70),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                saveFunction!(editController
                                    .text); // Call saveFunction when the button is pressed
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF7A3B69),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              taskName,
                              style: TextStyle(
                                color: Color.fromARGB(255, 245, 249, 248),
                                fontSize: 18,
                                decoration: taskCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            Text(
                              "Due Date: ${dueDate.toString().split(' ')[0]}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
