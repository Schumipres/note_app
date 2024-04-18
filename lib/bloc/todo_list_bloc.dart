import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/data/repository/todo_repository.dart';
import 'package:todo_app/models/todo_list_model.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final List<TodoModel> todosList = [];
  final TodoRepository todoRepository;

  TodoListBloc(this.todoRepository) : super(TodoListInitial()) {
    on<CreatedNote>(_createdNote);
    on<DeletedNote>(_deletedNote);
    on<UpdatedNote>(_updatedNote);
    on<FetchInitialTodos>(_initialFetchTodos);
    on<ClickedNote>(_clickedNote);
    on<ClickedPin>(_clickedPin);
  }

  void _initialFetchTodos(
      FetchInitialTodos event, Emitter<TodoListState> emit) async {
    print("JE PASSE ICI");
    emit(TodoListLoading());
    try {
      final todos = await todoRepository.todos();
      emit(TodoListLoaded(todos: todos));
    } catch (e) {
      emit(TodoListError(message: e.toString()));
    }
  }

  void _createdNote(CreatedNote event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      if (event.title.isEmpty) {
        emit(TodoListError(message: 'Title is empty'));
      } else {
        final newTodo = await todoRepository.add(TodoModel(
          title: event.title,
          description: 'test',
          isPinned: 0,
        ));
        emit(NavigateToDetailedScreen(todo: newTodo));
      }
    } catch (e) {
      emit(TodoListError(message: e.toString()));
    }
  }

  void _deletedNote(DeletedNote event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      await todoRepository.delete(event.index);

      final todos = await todoRepository.todos();
      //if todos is empty, emit TodoListInitial
      if (todos.isEmpty) {
        emit(TodoListInitial());
        return;
      }
      // Emit the updated todos
      emit(TodoListLoaded(todos: todos));
    } catch (e) {
      emit(TodoListError(message: e.toString()));
    }
  }

  void _updatedNote(UpdatedNote event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      print("Update try");
      final updateTodo = await todoRepository.update(
        TodoModel(
          id: event.index,
          title: event.title ?? '',
          description: event.description,
          isPinned: event.isPinned ?? 0,
        ),
      );
      if (event.noteIsClosed == true) {
        print("NOOOOOOOOOOOOOOOTE IS CLOSED");
        final todos = await todoRepository.todos();
        emit(TodoListLoaded(todos: todos));
        return;
      }
      emit(NavigateToDetailedScreen(todo: updateTodo));
    } catch (e) {
      print("Update catch: $e");
      emit(TodoListError(message: e.toString()));
    }
  }

  void _clickedNote(ClickedNote event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      final todo = await todoRepository.todoById(event.id);
      emit(NavigateToDetailedScreen(todo: todo));
    } catch (e) {
      emit(TodoListError(message: e.toString()));
    }
  }

  void _clickedPin(ClickedPin event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      // update the isPinned value of the given todo id by reversing the current value
      final todo = await todoRepository.todoById(event.id);
      await todoRepository.update(
        TodoModel(
          id: event.id,
          title: todo.title,
          description: todo.description,
          isPinned: todo.isPinned == 0 ? 1 : 0,
        ),
      );
      // Fetch the updated todos
      final todos = await todoRepository.todos();
      // place the pinned todo at the end of the list
      todos.sort((a, b) => a.isPinned.compareTo(b.isPinned));
      emit(TodoListLoaded(todos: todos));
    } catch (e) {
      emit(TodoListError(message: e.toString()));
    }
  }
}
