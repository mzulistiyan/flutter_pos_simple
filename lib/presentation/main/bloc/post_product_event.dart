part of 'post_product_bloc.dart';

abstract class PostProductEvent extends Equatable {
  const PostProductEvent();

  @override
  List<Object> get props => [];
}

class PostProduct extends PostProductEvent {
  final String? name;
  final int? stock;
  final int? price;
  final String? categoryID;
  final String? image;

  const PostProduct({
    this.name,
    this.stock,
    this.price,
    this.categoryID,
    this.image,
  });

  @override
  List<Object> get props => [name!, stock!, price!, categoryID!, image!];
}
