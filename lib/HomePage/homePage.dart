import 'package:flutter/material.dart';

import 'package:todo_list_app/DatabaseHelper/Database_Helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> _todos = [];
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _loadTodos();
  }

  void _loadTodos() async {
    List<Map<String, dynamic>> rows = await _databaseHelper.queryAllRows();
    setState(() {
      _todos = rows.map((row) => Todo.fromMap(row)).toList();
    });
  }

  void _addTodo() {
    String newTodoTitle = '';
    String newTodoDescription = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newTodoTitle = value;
                },
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value) {
                  newTodoDescription = value;
                },
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async {
                if (newTodoTitle.isNotEmpty) {
                  Todo newTodo = Todo(
                    title: newTodoTitle,
                    description: newTodoDescription,
                    completed: false,
                  );
                  await _databaseHelper.insert(newTodo.toMap());
                  _loadTodos();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editTodoDetails(int index) {
    String updatedTodoTitle = _todos[index].title;
    String updatedTodoDescription = _todos[index].description;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  updatedTodoTitle = value;
                },
                decoration: const InputDecoration(labelText: 'Title'),
                controller: TextEditingController(text: _todos[index].title),
              ),
              TextField(
                onChanged: (value) {
                  updatedTodoDescription = value;
                },
                decoration: const InputDecoration(labelText: 'Description'),
                controller:
                TextEditingController(text: _todos[index].description),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                Todo updatedTodo = Todo(
                  id: _todos[index].id,
                  title: updatedTodoTitle,
                  description: updatedTodoDescription,
                  completed: _todos[index].completed,
                );
                await _databaseHelper.update(updatedTodo.toMap());
                _loadTodos();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _removeTodoFromDatabase(int id) async {
    await _databaseHelper.delete(id);
    _loadTodos();
  }

  void _removeTodoConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Delete'),
              onPressed: () {
                _removeTodoFromDatabase(_todos[index].id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_todos[index].title),
            subtitle: Text(_todos[index].description),
            onTap: () {
              _editTodoDetails(index);
            },
            onLongPress: () {
              _removeTodoConfirmation(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _addTodo();
        },
      ),
    );
  }
}
class Todo {
  int? id;
  String title;
  String description;
  bool completed;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['_id'],
      title: map['title'],
      description: map['description'],
      completed: map['completed'] == 1,
    );
  }
}




