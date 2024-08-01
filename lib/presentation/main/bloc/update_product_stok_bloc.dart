import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';
import 'package:flutter_application_pos/common/common.dart';

import '../../../core/core.dart';

part 'update_product_stok_event.dart';

class UpdateProductStokBloc extends Bloc<UpdateProductStokEvent, BaseState> {
  final ProductRepository updateProductStokRepository;
  UpdateProductStokBloc(this.updateProductStokRepository) : super(InitializedState()) {
    on<UpdateProductStok>((event, emit) async {
      emit(LoadingState());
      final result = await updateProductStokRepository.updateProductStock(
        id: event.id,
        stock: event.stok,
      );
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(LoadedState(data: data)),
      );
    });
  }
}
