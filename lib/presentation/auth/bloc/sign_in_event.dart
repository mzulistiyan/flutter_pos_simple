part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInWithNIKAndPassword extends SignInEvent {
  final String email;
  final String password;

  const SignInWithNIKAndPassword({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}