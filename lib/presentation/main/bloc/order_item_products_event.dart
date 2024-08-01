part of 'order_item_products_bloc.dart';

abstract class OrderItemProductsEvent extends Equatable {
  const OrderItemProductsEvent();

  @override
  List<Object> get props => [];
}

class PostOrderItemProducts extends OrderItemProductsEvent {
  final int productId;
  final int quantity;
  final int price;
  final int orderID;

  const PostOrderItemProducts({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.orderID,
  });

  @override
  List<Object> get props => [productId, quantity, price, orderID];
}
