part of 'order_product_bloc.dart';

abstract class OrderProductEvent extends Equatable {
  const OrderProductEvent();

  @override
  List<Object> get props => [];
}

class PostOrderProduct extends OrderProductEvent {
  final int amount;

  const PostOrderProduct({
    required this.amount,
  });

  @override
  List<Object> get props => [amount];
}
