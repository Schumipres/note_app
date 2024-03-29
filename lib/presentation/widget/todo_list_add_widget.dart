import 'package:flutter/material.dart';

class TodoListAddWidget extends StatelessWidget {
  const TodoListAddWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingActionButton(
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
