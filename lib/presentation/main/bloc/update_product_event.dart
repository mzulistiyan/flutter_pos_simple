part of 'update_product_bloc.dart';

abstract class UpdateProductEvent extends Equatable {
  const UpdateProductEvent();

  @override
  List<Object> get props => [];
}

class UpdateProduct extends UpdateProductEvent {
  final String? id;
  final String? name;
  final int? stock;
  final int? price;
  final String? categoryID;
  final String? image;

  const UpdateProduct({
    this.id,
    this.name,
    this.stock,
    this.price,
    this.categoryID,
    this.image,
  });

  @override
  List<Object> get props => [id!, name!, stock!, price!, categoryID!, image!];
}
