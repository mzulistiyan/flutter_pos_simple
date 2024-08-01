part of 'get_order_by_date_bloc.dart';

abstract class GetOrderByDateEvent extends Equatable {
  const GetOrderByDateEvent();

  @override
  List<Object> get props => [];
}

class FetchOrderByDate extends GetOrderByDateEvent {}
