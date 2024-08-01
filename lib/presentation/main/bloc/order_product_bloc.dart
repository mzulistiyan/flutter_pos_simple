import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';
import 'package:flutter_application_pos/common/common.dart';
import 'package:flutter_application_pos/core/core.dart';

part 'order_product_event.dart';

class OrderProductBloc extends Bloc<OrderProductEvent, BaseState<String>> {
  final ProductRepository orderProductRepository;
  OrderProductBloc(this.orderProductRepository) : super(const InitializedState()) {
    on<PostOrderProduct>((event, emit) async {
      emit(const LoadingState());
      final result = await orderProductRepository.orderProduct(amount: event.amount);
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(LoadedState(data: data)),
      );
    });
  }
}
