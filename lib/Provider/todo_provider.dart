import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/DatabaseHelper/Database_Helper.dart';
import 'todo_model.dart';
import 'package:todo_list_app/Provider/todo_provider.dart';

class TodoProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    final rows = await _databaseHelper.queryAllRows();
    _todos = rows.map((row) => Todo.fromMap(row)).toList();
    notifyListeners();
  }

  Future<void> addTodo({
    required String title,
    required String description,
    required bool completed,
  }) async {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      completed: completed,
    );
    await _databaseHelper.insert(newTodo.toMap());
    _todos.add(newTodo);
    notifyListeners();
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    await _databaseHelper.update(updatedTodo.toMap());
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index >= 0) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

  Future<void> deleteTodo(int id) async {
    await _databaseHelper.delete(id);
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}

extension TodoProviderExtension on BuildContext {
  TodoProvider get todoProvider => read<TodoProvider>();
}