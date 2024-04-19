import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:note_app/data/repository/note_repository.dart';
import 'package:note_app/models/note_list_model.dart';

part 'note_list_event.dart';
part 'note_list_state.dart';

class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {
  final List<TodoModel> todosList = [];
  final TodoRepository todoRepository;

  NoteListBloc(this.todoRepository) : super(NoteListInitial()) {
    on<CreatedNote>(_createdNote);
    on<DeletedNote>(_deletedNote);
    on<UpdatedNote>(_updatedNote);
    on<ClickedNote>(_clickedNote);
    on<ClickedPin>(_clickedPin);
    on<FetchInitialTodos>(_initialFetchTodos);
  }

  void _initialFetchTodos(
      FetchInitialTodos event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try {
      final todos = await todoRepository.todos();
      if (todos.isEmpty) {
        emit(NoteListEmpty());
        return;
      }
      emit(NoteListLoaded(todos: todos));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  void _createdNote(CreatedNote event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try {
      // if (event.title.isEmpty) {
      //   emit(NoteListError(message: 'Title is empty'));
      // } else {
      final newTodo = await todoRepository.add(TodoModel(
        title: event.title,
        description: 'test',
        isPinned: 0,
      ));
      emit(NavigateToDetailedScreen(todo: newTodo));
      // }
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  void _deletedNote(DeletedNote event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try {
      await todoRepository.delete(event.index);

      final todos = await todoRepository.todos();
      //if todos is empty, emit NoteListInitial
      if (todos.isEmpty) {
        emit(NoteListInitial());
        return;
      }
      // Emit the updated todos
      emit(NoteListLoaded(todos: todos));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  void _updatedNote(UpdatedNote event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try {
      final updateTodo = await todoRepository.update(
        TodoModel(
          id: event.index,
          title: event.title ?? '',
          description: event.description,
          isPinned: event.isPinned ?? 0,
        ),
      );
      // to close the note
      if (event.noteIsClosed == true) {
        final todos = await todoRepository.todos();
        emit(NoteListLoaded(todos: todos));
        return;
      }
      emit(NavigateToDetailedScreen(todo: updateTodo));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  void _clickedNote(ClickedNote event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try {
      final todo = await todoRepository.todoById(event.id);
      emit(NavigateToDetailedScreen(todo: todo));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  void _clickedPin(ClickedPin event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
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
      emit(NoteListLoaded(todos: todos));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }
}
