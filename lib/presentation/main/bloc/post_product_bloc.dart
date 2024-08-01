import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';

import '../../../core/core.dart';

part 'post_product_event.dart';

class PostProductBloc extends Bloc<PostProductEvent, BaseState<String>> {
  final ProductRepository productRepository;
  PostProductBloc(this.productRepository) : super(const InitializedState()) {
    on<PostProduct>((event, emit) async {
      emit(const LoadingState());
      final result = await productRepository.postProduct(
        name: event.name!,
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
