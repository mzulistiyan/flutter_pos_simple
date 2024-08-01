part of 'get_categories_bloc.dart';

abstract class GetCategoriesEvent extends Equatable {
  const GetCategoriesEvent();

  @override
  List<Object> get props => [];
}

class FetchCategories extends GetCategoriesEvent {}
