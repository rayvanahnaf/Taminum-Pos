import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasource/product_remote_datasource.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/response/product_response_model.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource productRemoteDatasource;
  List<Product> products = [];
  ProductBloc(this.productRemoteDatasource) : super(ProductInitial()) {
    on<ProductFetched>((event, emit) async {
      print('[ProductBloc] Fetching products...');
      emit(ProductLoading());
      final response = await productRemoteDatasource.getProducts();
      response.fold(
            (l) {
          print('[ProductBloc] Failed: $l');
          emit(ProductFailure(message: l));
        },
            (r) {
          products = r.product;
          print('[ProductBloc] Success: ${r.product.length} items');
          emit(ProductSuccess(r.product));
        },
      );
    });

    on<ProductCategoryFetched>((event, emit) async {
      emit(ProductLoading());
      final response = await productRemoteDatasource.getProducts();
      final filteredProducts = event.category == 'all' ? products : products
          .where((product) => product.category == event.category)
          .toList();

      response.fold(
              (l) => emit(ProductFailure(message: l)),
              (r) {
            emit(ProductSuccess(filteredProducts),);
          }
      );
    });

  }
}