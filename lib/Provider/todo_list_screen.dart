import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_list_app/DatabaseHelper/Database_Helper.dart';
import 'todo_provider.dart';

import 'package:todo_list_app/Provider/todo_model.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoListScreen(),
      ),
    );
  }
}

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoProvider = context.todoProvider;
    final todos = todoProvider.todos;

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoDetailsScreen(todo: todo),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTodoScreen(),
            ),
          );
        },
      ),
    );
  }
}

class AddTodoScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.todoProvider;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                final title = _titleController.text;
                final description = _descriptionController.text;
                if (title.isNotEmpty) {
                  todoProvider.addTodo(
                    title: title,
                    description: description,
                    completed: false,
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TodoDetailsScreen extends StatelessWidget {
  final  Todo todo;

  const TodoDetailsScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.todoProvider;

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(todo.description),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Complete'),
              onPressed: () {
                final updatedTodo = Todo(
                  id: todo.id,
                  title: todo.title,
                  description: todo.description,
                  completed: true,
                );
                todoProvider.updateTodo(updatedTodo);
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () {
                todoProvider.deleteTodo(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}