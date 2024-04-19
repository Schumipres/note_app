part of 'note_list_bloc.dart';

@immutable
sealed class NoteListEvent {}

class FetchInitialTodos extends NoteListEvent {}

class CreatedNote extends NoteListEvent {
  final String title;

  CreatedNote({
    required this.title,
  });
}

class DeletedNote extends NoteListEvent {
  final int index;

  DeletedNote({
    required this.index,
  });
}

class UpdatedNote extends NoteListEvent {
  //TODO change to use model
  final int index;
  final int? isPinned;
  final String? title;
  final String? description;
  final bool? noteIsClosed;

  UpdatedNote({
    required this.index,
    this.isPinned,
    this.title,
    this.description,
    this.noteIsClosed,
  });
}

// event clicked on a note from the list
class ClickedNote extends NoteListEvent {
  final int id;

  ClickedNote({
    required this.id,
  });
}

// event clicked on Pin button from the list
class ClickedPin extends NoteListEvent {
  final int id;

  ClickedPin({
    required this.id,
  });
}
