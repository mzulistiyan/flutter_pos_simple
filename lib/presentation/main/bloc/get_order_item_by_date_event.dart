part of 'get_order_item_by_date_bloc.dart';

abstract class GetOrderItemByDateEvent extends Equatable {
  const GetOrderItemByDateEvent();

  @override
  List<Object> get props => [];
}

class FetchOrderItemByDate extends GetOrderItemByDateEvent {}
