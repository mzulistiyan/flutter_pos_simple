part of 'delete_product_bloc.dart';

abstract class DeleteProductEvent extends Equatable {
  const DeleteProductEvent();

  @override
  List<Object> get props => [];
}

class DeleteProduct extends DeleteProductEvent {
  final int? id;

  const DeleteProduct({
    this.id,
  });

  @override
  List<Object> get props => [id!];
}
