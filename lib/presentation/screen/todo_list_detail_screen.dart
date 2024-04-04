import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_list_bloc.dart';
import 'dart:async';

class TodoListDetailScreen extends StatelessWidget {
  const TodoListDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the arguments using ModalRoute
    final arguments = ModalRoute.of(context)?.settings.arguments;

    // Timer
    Timer? _timer;

    // Reset timer function
    void _resetTimer(String value, int index) {
      // Cancel the previous timer, if any
      _timer?.cancel();
      // Start a new timer
      _timer = Timer(Duration(seconds: 2), () {
        print('Auto-saving... $value, $index');
        // Auto-save after 2 seconds of inactivity
        context.read<TodoListBloc>().add(
              UpdatedNote(
                index: index,
                description: value,
              ),
            );
      });
    }

    // Check if arguments is not null and is of the expected type
    if (arguments != null && arguments is int) {
      // Use the arguments as needed
      final index = arguments;
      // Now you can access todo and its properties
      return BlocBuilder<TodoListBloc, TodoListState>(
        builder: (context, state) {
          if (state is TodoListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TodoListLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: GestureDetector(
                  onTap: () {
                    // Handle the tap event to make the title editable
                    // You can use a dialog or navigate to a new screen for editing
                    // For simplicity, let's show a dialog
                    showDialog(
                      context: context,
                      builder: (context) {
                        String editedTitle = state.todos[index].title;
                        return AlertDialog(
                          title: Text(
                            'Edit Title',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                          content: TextFormField(
                            initialValue: state.todos[index].title,
                            onChanged: (value) {
                              editedTitle = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context.read<TodoListBloc>().add(
                                      UpdatedNote(
                                        index: index,
                                        title: editedTitle,
                                      ),
                                    );
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    state.todos[index].title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: TextEditingController(
                      text: state.todos[index].description),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: null,
                  style: const TextStyle(
                    fontSize: 19,
                    height: 1.5,
                  ),
                  onChanged: (value) {
                    // Reset the timer when the text changes
                    _resetTimer(value, index);
                  },
                ),
              ),
            );
          }
          return Container();
        },
      );
    }
    return Container();
  }
}
