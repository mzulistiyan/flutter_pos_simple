part of 'get_product_bloc.dart';

abstract class GetProductEvent extends Equatable {
  const GetProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProduct extends GetProductEvent {
  final String? categoryID;

  const FetchProduct({this.categoryID});

  @override
  List<Object> get props => [categoryID!];
}
