
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/todo_model.dart';

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  void addTodo(String name) {
    if (name.isEmpty) {
      addError('Name is empty');
      return;
    }
    final todo = Todo(
      name: name,
      createdTime: DateTime.now(),
    );
    emit([...state, todo]);
  }

  // onChange method is called whenever the state of the cubit changes
  @override
  void onChange(Change<List<Todo>> change) {
    super.onChange(change);
    print('TodoCubit - $change');
  }

  // onError method is called whenever an error is thrown within the cubit
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print('TodoCubit - $error');
  }
}
