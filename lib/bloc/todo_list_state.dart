part of 'todo_list_bloc.dart';

@immutable
sealed class TodoListState {}

final class TodoListInitial extends TodoListState {}

final class TodoListLoading extends TodoListState {}

final class TodoListError extends TodoListState {
  final String message;
  

  TodoListError({
    required this.message,
  });

}

final class TodoListLoaded extends TodoListState {
  final List<TodoListModel> todos;

  TodoListLoaded({
    required this.todos,
  });
}
