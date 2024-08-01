import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';
import 'package:flutter_application_pos/common/common.dart';

import '../../../core/core.dart';

part 'get_order_by_date_event.dart';

class GetOrderByDateBloc extends Bloc<GetOrderByDateEvent, BaseState<List<OrderEntity>>> {
  final ProductRepository repository;
  GetOrderByDateBloc(this.repository) : super(const InitializedState()) {
    on<FetchOrderByDate>((event, emit) async {
      emit(const LoadingState());
      final result = await repository.getOrderByDate();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(LoadedState(data: data)),
      );
    });
  }
}
