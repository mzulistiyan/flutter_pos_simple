import 'package:equatable/equatable.dart';

/// abstract class base state
abstract class BaseState<T> extends Equatable {
  final T? data;
  final bool? hasReachedMax;

  const BaseState({this.data, this.hasReachedMax});

  @override
  List<Object?> get props => [data, hasReachedMax];
}

/// initialized state
class InitializedState<T> extends BaseState<T> {
  const InitializedState() : super();
}

/// unauthentication state
class UnAuthenticationState<T> extends BaseState<T> {
  final bool? isFirst;

  const UnAuthenticationState({this.isFirst}) : super();
}

/// authenticated state
class AuthenticatedState<T> extends BaseState<T> {
  const AuthenticatedState({T? data}) : super(data: data);
}

/// authenticated state
class ForceLogoutState<T> extends BaseState<T> {
  const ForceLogoutState({T? data}) : super(data: data);
}

/// loading state
class LoadingState<T> extends BaseState<T> {
  const LoadingState() : super();
}

/// empty state
class EmptyState<T> extends BaseState<T> {
  const EmptyState() : super();
}

/// loaded state
class LoadedState<T> extends BaseState<T> {
  final int? page;
  final bool? hasReachedMax;

  const LoadedState({
    T? data,
    this.page,
    this.hasReachedMax,
  }) : super(data: data);

  @override
  List<Object?> get props => [data, page, hasReachedMax];
}

/// success state
class SuccessState<T> extends BaseState<T> {
  final String? message;
  final String? type;
  final int? page;

  const SuccessState({
    T? data,
    this.message,
    this.type,
    this.page,
  }) : super(data: data);

  @override
  List<Object?> get props => [
        data,
        message,
        type,
        page,
      ];
}

/// error state
class ErrorState<T> extends BaseState<T> {
  final String? message;
  final String? type;

  const ErrorState({
    T? data,
    this.message,
    this.type,
  }) : super(data: data);

  @override
  List<Object?> get props => [
        data,
        message,
        type,
      ];
}
