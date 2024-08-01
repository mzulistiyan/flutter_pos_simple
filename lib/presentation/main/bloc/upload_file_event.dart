part of 'upload_file_bloc.dart';

abstract class UploadFileEvent extends Equatable {}

class UploadFile extends UploadFileEvent {
  final String? filePath;
  final String? fileName;

  UploadFile({this.filePath, this.fileName});

  @override
  List<Object> get props => [filePath!, fileName!];
}
