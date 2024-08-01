import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';

import '../../../common/common.dart';
import '../../../core/core.dart';

part 'get_product_event.dart';

class GetProductBloc extends Bloc<GetProductEvent, BaseState<List<ProductEntity>>> {
  final ProductRepository productRepository;

  GetProductBloc(this.productRepository) : super(const InitializedState()) {
    on<FetchProduct>((event, emit) async {
      emit(const LoadingState());
      final result = await productRepository.getProduct(categoryID: event.categoryID);
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(LoadedState(
          data: data,
        )),
      );
    });
  }
}

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_application_pos/common/base_state/base_state.dart';

// import '../../../common/common.dart';
// import '../../../core/core.dart';

// part 'get_product_event.dart';

// class GetProductBloc extends Bloc<GetProductEvent, BaseState<List<ProductEntity>>> {
//   final ProductRepository productRepository;
//   Map<int, List<ProductEntity>> productsCache = {};

//   GetProductBloc(this.productRepository) : super(const InitializedState()) {
//     on<FetchProduct>((event, emit) async {
//       final categoryID = event.categoryID != null ? int.tryParse(event.categoryID!) : 0;

//       if (productsCache.containsKey(categoryID)) {
//         // Use cached products
//         emit(LoadedState(data: productsCache[categoryID]!));
//       } else {
//         emit(const LoadingState());
//         final result = await productRepository.getProduct(categoryID: event.categoryID);
//         result.fold(
//           (failure) => emit(ErrorState(message: failure.message)),
//           (data) {
//             productsCache[categoryID!] = data;
//             emit(LoadedState(data: data));
//           },
//         );
//       }
//     });
//   }
// }
