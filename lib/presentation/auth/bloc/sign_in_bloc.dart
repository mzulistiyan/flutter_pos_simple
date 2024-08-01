import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';
import 'package:flutter_application_pos/common/common.dart';

import '../../../core/core.dart';
part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, BaseState> {
  final AuthRepository signIn;
  SignInBloc({required this.signIn}) : super(const InitializedState()) {
    on<SignInWithNIKAndPassword>((event, emit) async {
      emit(const LoadingState());

      final result = await signIn.signIn(email: event.email, password: event.password);
      result.fold(
        (failure) {
          emit(ErrorState(message: failure.message));
        },
        (data) {
          emit(SuccessState(data: data));
        },
      );
    });
  }
}
