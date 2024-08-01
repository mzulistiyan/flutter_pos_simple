import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';
import 'package:flutter_application_pos/common/common.dart';

import '../../../core/core.dart';

part 'delete_product_event.dart';

class DeleteProductBloc extends Bloc<DeleteProductEvent, BaseState> {
  final ProductRepository productRepository;
  DeleteProductBloc(this.productRepository) : super(const InitializedState()) {
    on<DeleteProduct>((event, emit) async {
      emit(const LoadingState());
      final result = await productRepository.deleteProduct(id: event.id!);
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(const SuccessState()),
      );
    });
  }
}
