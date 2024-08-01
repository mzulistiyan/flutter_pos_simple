import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';
import 'package:flutter_application_pos/common/common.dart';

import '../../../core/core.dart';

part 'get_order_by_month_event.dart';

class GetOrderByMonthBloc extends Bloc<GetOrderByMonthEvent, BaseState<List<OrderEntity>>> {
  final ProductRepository repository;
  GetOrderByMonthBloc(this.repository) : super(const InitializedState()) {
    on<FetchOrderByMonth>((event, emit) async {
      emit(const LoadingState());
      final result = await repository.getOrderByMonth();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(LoadedState(data: data)),
      );
    });
  }
}
