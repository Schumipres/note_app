import 'dart:convert';

import 'package:todo_app/data/providers/todo_db.dart';
import 'package:todo_app/models/todo_list_model.dart';

class TodoRepository {
  final TodoProvider todoProvider;
  TodoRepository(this.todoProvider);

  // Fetch todos
  Future<List<TodoModel>> todos() async {
    try {
      final List<TodoModel> todos = await todoProvider.todos();
      print("todos: $todos");

      return todos;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  // Add todo
  Future<TodoModel> add(TodoModel todo) async {
    try {
      await todoProvider.insert(todo);

      // Return the added todo by fetching it from the database
      return await todoProvider.lastTodo();
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  // Update todo return the updated todo
  Future<TodoModel> update(TodoModel todo) async {
    try {
      await todoProvider.update(todo);

      //return the updated todo by fetching it from the database
      return await todoProvider.todoById(todo.id!);
    } catch (e) {
      rethrow;
    }
  }

  // Delete todo
  Future<void> delete(int id) async {
    try {
      await todoProvider.delete(id);
    } catch (e) {
      print("EEEEEEEEEEEERRREUR: $e");
      rethrow;
    }
  }

  // Get todo by id
  Future<TodoModel> todoById(int id) async {
    try {
      return await todoProvider.todoById(id);
    } catch (e) {
      rethrow;
    }
  }
}
