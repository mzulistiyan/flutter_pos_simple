import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/common.dart';

import '../../../core/core.dart';

part 'order_item_products_event.dart';

class OrderItemProductsBloc extends Bloc<OrderItemProductsEvent, BaseState> {
  final ProductRepository orderItemProductsRepository;
  OrderItemProductsBloc(this.orderItemProductsRepository) : super(const InitializedState()) {
    on<PostOrderItemProducts>((event, emit) async {
      emit(const LoadingState());
      final result = await orderItemProductsRepository.orderItemsProduct(
        productId: event.productId,
        quantity: event.quantity,
        price: event.price,
        orderID: event.orderID,
      );
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(LoadedState(data: data)),
      );
    });
  }
}
