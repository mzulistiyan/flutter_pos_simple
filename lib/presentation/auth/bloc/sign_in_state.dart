part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String message;

  const SignInSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class SignInFailure extends SignInState {
  final String message;

  const SignInFailure({required this.message});

  @override
  List<Object> get props => [message];
}
