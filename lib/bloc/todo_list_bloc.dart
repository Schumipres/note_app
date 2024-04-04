import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/models/todo_list_model.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final List<TodoListModel> newTodos = [];

  TodoListBloc() : super(TodoListInitial()) {
    on<CreatedNote>(_createdNote);
    on<DeletedNote>(_deletedNote);
    on<UpdatedNote>(_updatedNote);
  }

  void _createdNote(CreatedNote event, Emitter<TodoListState> emit) {
    emit(TodoListLoading());
    try {
      if (event.title.isEmpty) {
        emit(TodoListError(message: 'Title is empty'));
      } else {
        final newTodo = TodoListModel(
          title: event.title,
          isPinned: false,
        );

        newTodos.add(newTodo);
      }
      emit(TodoListLoaded(todos: newTodos));
    } catch (e) {
      emit(TodoListError(message: e.toString()));
    }
  }

  void _deletedNote(DeletedNote event, Emitter<TodoListState> emit) {
    emit(TodoListLoading());
    try {
      newTodos.removeAt(event.index);
      if (newTodos.isEmpty) {
        emit(TodoListInitial());
        return;
      }
      emit(TodoListLoaded(todos: newTodos));
    } catch (e) {
      emit(TodoListError(message: e.toString()));
    }
  }

  void _updatedNote(UpdatedNote event, Emitter<TodoListState> emit) {
    emit(TodoListLoading());
    try {
      newTodos[event.index] = newTodos[event.index].copyWith(
        isPinned: event.isPinned ?? newTodos[event.index].isPinned,
        title: event.title ?? newTodos[event.index].title,
        description: event.description ?? newTodos[event.index].description,
      );
      // print the updated todo
      print("Updated todo: ${newTodos[event.index]}");

      // if isPinned is true, push it to the top of the list
      if (event.isPinned == true) {
        final todo = newTodos.removeAt(event.index);
        newTodos.insert(0, todo);
      }

      emit(TodoListLoaded(todos: newTodos));
    } catch (e) {
      emit(TodoListError(message: e.toString()));
    }
  }
}
