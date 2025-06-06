part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class ProductFetched extends ProductEvent {}


class ProductCategoryFetched extends ProductEvent {

  final String category;

  ProductCategoryFetched({required this.category});

}