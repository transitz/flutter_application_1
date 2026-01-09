import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/services/database_service.dart';
//import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  String? _task = null;

  @override
  Widget build(Object other) {
    return Scaffold(floatingActionButton: _addTaskButton(), body: _tasksList());
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Add Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _task = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      _task = value;
                    });
                  },
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "enter task here...",
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if (_task == null || _task == "") return;
                    _databaseService.addTask(_task!);
                    setState(() {
                      _task = null;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _tasksList() {
    return FutureBuilder(
      future: _databaseService.getTasks(),
      //builder for data return to build the widget
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            Task task = snapshot.data![index];
            return ListTile(
              onLongPress: () {
                //make prompt confirmation for delete
                confirmDeleteTask(task.id, task.content);
                //  setState(() {});
              },
              title: Text(task.content),
              trailing: Checkbox(
                value: task.status == 1,
                onChanged: (value) {
                  _databaseService.updateTaskStatus(
                    task.id,
                    value == true ? 1 : 0,
                  );
                  setState(() {});
                },
              ),
            );
          },
        );
      },
    );
  }

  void confirmDeleteTask(int taskId, String taskContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete task: '$taskContent' ?",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("CANCEL"),
              onPressed: () {
                //dismiss the dialog
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("DELETE"),
              onPressed: () {
                //setState is here to update List and UI
                setState(() {
                  //deletes the task
                  _databaseService.deleteTask(taskId);
                  _showSnackBar(context, taskContent);                
                });
                //dismiss the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String displayVar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Successfully deleted '$displayVar'"),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
