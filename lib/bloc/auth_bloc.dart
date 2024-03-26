import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  // @override
  // void onChange(Change<AuthState> change) {
  //   super.onChange(change);
  //   print('AuthBloc - Change - $change');
  // }

  // @override
  // void onTransition(Transition<AuthEvent, AuthState> transition) {
  //   super.onTransition(transition);
  //   print('AuthBloc - Transition - $transition');
  // }

  void _onAuthLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final email = event.email;
      final password = event.password;

      // Email validation using regex
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        emit(AuthFailure(error: 'Invalid email address.'));
        return;
      }
      // Password validation
      if (password.length < 6) {
        emit(
            AuthFailure(error: 'Password must be at least 6 characters long.'));
        return;
      }

      // Simulate network request
      await Future.delayed(const Duration(seconds: 1), () {
        emit(AuthSuccess(uid: '$email-$password'));
        return;
      });
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  void _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Simulate network request
      await Future.delayed(const Duration(seconds: 1), () {
        emit(AuthInitial());
        return;
      });
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
