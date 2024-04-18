import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app_bloc_observer.dart';
import 'package:todo_app/bloc/todo_list_bloc.dart';
import 'package:todo_app/data/providers/todo_db.dart';
import 'package:todo_app/data/repository/todo_repository.dart';
import 'package:todo_app/models/todo_list_model.dart';
import 'package:todo_app/presentation/screen/todo_list_detail_screen.dart';
import 'package:todo_app/presentation/screen/todo_list_screen.dart';
import 'package:todo_app/theme/dark_mode.dart';
import 'package:todo_app/theme/light_mode.dart';

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
        create: (context) => TodoListBloc(context.read<TodoRepository>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: lightMode,
          darkTheme: darkMode,
          home: const TodoListScreen(),
          initialRoute: '/todo_list_screen',
          routes: {
            '/todo_list_screen': (context) => const TodoListScreen(),
            '/todo_list_detail_screen': (context) =>
                const TodoListDetailScreen(),
          },
        ),
      ),
    );
  }
}
