import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';
import 'package:flutter_application_pos/common/common.dart';

import '../../../core/core.dart';

part 'get_order_item_by_date_event.dart';

class GetOrderItemByDateBloc extends Bloc<GetOrderItemByDateEvent, BaseState<List<OrderItemEntity>>> {
  final ProductRepository repository;
  GetOrderItemByDateBloc(this.repository) : super(const InitializedState()) {
    on<FetchOrderItemByDate>((event, emit) async {
      emit(const LoadingState());
      final result = await repository.getOrderItemsToday();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(LoadedState(data: data)),
      );
    });
  }
}
