import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_pos/common/base_state/base_state.dart';
import 'package:flutter_application_pos/core/core.dart';

part 'upload_file_event.dart';

class UploadFileBloc extends Bloc<UploadFileEvent, BaseState<String>> {
  final ProductRepository productRepository;
  UploadFileBloc(this.productRepository) : super(InitializedState()) {
    on<UploadFile>((event, emit) async {
      emit(LoadingState());
      final result = await productRepository.uploadFile(
        filePath: event.filePath!,
        file: event.fileName!,
      );
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (data) => emit(LoadedState(data: data)),
      );
    });
  }
}
