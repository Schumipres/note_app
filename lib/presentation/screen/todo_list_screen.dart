import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_list_bloc.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: BlocConsumer<TodoListBloc, TodoListState>(
                listener: (context, state) {
                  if (state is TodoListError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                    ));
                  }
                },
                builder: (context, state) {
                  if (state is TodoListInitial) {
                    return Center(
                      child: Text(
                        'No notes yet...',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    );
                  } else if (state is TodoListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TodoListLoaded) {
                    return ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
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
                              Checkbox(
                                value: state.todos[index].isDone,
                                onChanged: (value) {
                                  context.read<TodoListBloc>().add(
                                        UpdatedNote(
                                          index: index,
                                          isDone: !state.todos[index].isDone,
                                        ),
                                      );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  context.read<TodoListBloc>().add(
                                        DeletedNote(
                                          index: index,
                                        ),
                                      );
                                },
                              ),
                            ],
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String note = ''; // Add a variable to store the note text
              return AlertDialog(
                title: Center(child: Text('Write Note')),
                content: TextField(
                  onChanged: (value) {
                    note =
                        value; // Update the note variable when the text changes
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your note',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Handle send button action here
                      print(
                          'Note: $note'); // Print the note for testing purposes
                      context.read<TodoListBloc>().add(
                          CreatedNote(title: note)); // Add the note to the list
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Send',
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
