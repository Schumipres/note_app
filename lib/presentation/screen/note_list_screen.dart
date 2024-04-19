import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/bloc/note_list_bloc.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120, bottom: 20),
            child: Center(
              child: Text(
                'Note',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Container(
              height: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: BlocConsumer<NoteListBloc, NoteListState>(
              listener: (context, state) {
                if (state is NoteListError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                  ));
                }
              },
              builder: (context, state) {
                if (state is NoteListInitial) {
                  context.read<NoteListBloc>().add(
                        FetchInitialTodos(),
                      );
                  return const Scaffold();
                } else if (state is NoteListEmpty) {
                  return Center(
                    child: Text(
                      'No notes yet...',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  );
                } else if (state is NoteListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NoteListLoaded) {
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.read<NoteListBloc>().add(
                                ClickedNote(
                                  id: state.todos[index].id!,
                                ),
                              );
                          Navigator.pushNamed(
                            context,
                            '/todo_list_detail_screen',
                          );
                        },
                        child: ListTile(
                          title: Text(
                            state.todos[index].title,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  state.todos[index].isPinned == 1
                                      ? Icons.push_pin
                                      : Icons.push_pin_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                                onPressed: () {
                                  context.read<NoteListBloc>().add(
                                        ClickedPin(
                                          id: state.todos[index].id!,
                                        ),
                                      );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                                onPressed: () {
                                  context.read<NoteListBloc>().add(
                                        DeletedNote(
                                          index: state.todos[index].id!,
                                        ),
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<NoteListBloc, NoteListState>(
        builder: (context, state) {
          print("State: $state");
          //print what in the state
          if (state is NoteListLoaded) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              onPressed: () {
                context.read<NoteListBloc>().add(
                    CreatedNote(title: "New note")); // Add the note to the list
                Navigator.pushNamed(context, '/todo_list_detail_screen');
              },
            );
          } else if (state is NoteListInitial || state is NoteListEmpty) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              onPressed: () {
                context.read<NoteListBloc>().add(
                    CreatedNote(title: "New note")); // Add the note to the list
                Navigator.pushNamed(context, '/todo_list_detail_screen');
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
