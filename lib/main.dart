import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/app_bloc_observer.dart';
import 'package:note_app/bloc/note_list_bloc.dart';
import 'package:note_app/data/providers/note_db.dart';
import 'package:note_app/data/repository/note_repository.dart';
import 'package:note_app/models/note_list_model.dart';
import 'package:note_app/presentation/screen/note_list_detail_screen.dart';
import 'package:note_app/presentation/screen/note_list_screen.dart';
import 'package:note_app/theme/dark_mode.dart';
import 'package:note_app/theme/light_mode.dart';

void main() async {
  // Ensure that the TodoProvider database is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the database
  await TodoProvider.init();
  Bloc.observer = AppBlocObeserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodoRepository(TodoProvider()),
      child: BlocProvider(
        create: (context) => NoteListBloc(context.read<TodoRepository>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: lightMode,
          darkTheme: darkMode,
          home: const NoteListScreen(),
          initialRoute: '/todo_list_screen',
          routes: {
            '/todo_list_screen': (context) => const NoteListScreen(),
            '/todo_list_detail_screen': (context) =>
                const NoteListDetailScreen(),
          },
        ),
      ),
    );
  }
}
