part of 'get_order_by_month_bloc.dart';

abstract class GetOrderByMonthEvent extends Equatable {
  const GetOrderByMonthEvent();

  @override
  List<Object> get props => [];
}

class FetchOrderByMonth extends GetOrderByMonthEvent {}
