part of 'todo_list_bloc.dart';

@immutable
sealed class TodoListEvent {}

class CreatedNote extends TodoListEvent {
  final String title;

  CreatedNote({
    required this.title,
  });
}

class DeletedNote extends TodoListEvent {
  final int index;

  DeletedNote({
    required this.index,
  });
}

class UpdatedNote extends TodoListEvent {
  final int index;
  final bool isDone;

  UpdatedNote({
    required this.index,
    required this.isDone,
  });
}