import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app_bloc_observer.dart';
import 'package:todo_app/bloc/todo_list_bloc.dart';
import 'package:todo_app/presentation/screen/todo_list_detail_screen.dart';
import 'package:todo_app/presentation/screen/todo_list_screen.dart';
import 'package:todo_app/theme/dark_mode.dart';
import 'package:todo_app/theme/light_mode.dart';

void main() {
  Bloc.observer = AppBlocObeserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoListBloc(),
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightMode,
        darkTheme: darkMode,
        home: TodoListScreen(),
        initialRoute: '/todo_list_screen',
        routes: {
          '/todo_list_screen': (context) => const TodoListScreen(),
          '/todo_list_detail_screen': (context) => const TodoListDetailScreen(),
        },
      ),
    );
  }
}
