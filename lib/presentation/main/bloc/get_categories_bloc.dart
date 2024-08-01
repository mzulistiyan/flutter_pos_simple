import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/common.dart';

import '../../../core/core.dart';

part 'get_categories_event.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, BaseState<List<CategoryProductEntity>>> {
  final ProductRepository productRepository;
  GetCategoriesBloc(this.productRepository) : super(const InitializedState()) {
    on<FetchCategories>((event, emit) async {
      emit(const LoadingState());
      final result = await productRepository.getCategory();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(LoadedState(
          data: data,
        )),
      );
    });
  }
}
