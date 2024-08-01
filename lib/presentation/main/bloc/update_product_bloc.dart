import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';

import '../../../core/core.dart';

part 'update_product_event.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, BaseState<String>> {
  final ProductRepository productRepository;
  UpdateProductBloc(this.productRepository) : super(const InitializedState()) {
    on<UpdateProduct>((event, emit) async {
      emit(const LoadingState());
      final result = await productRepository.updateProduct(
        name: event.name!,
        id: int.tryParse(event.id!)!,
        stock: event.stock!,
        price: event.price!,
        categoryID: event.categoryID!,
        image: event.image!,
      );
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(LoadedState(data: data)),
      );
    });
  }
}
