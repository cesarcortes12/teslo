import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductsRepository productsRepository;

  ProductCubit({
    required this.productsRepository,
  }) : super(ProductState()) {}

  Future<void> loadProduct(id) async {
    try {
      final product = await productsRepository.getProductById(id);
      emit(state.copyWith(product: product));
    } catch (e) {
      //404 product not found
      print(e);
    }
  }

  Future<void> clean() async {
    try {
      emit(state.copyWith(product: null));
    } catch (e) {
      //404 product not found
      print(e);
    }
  }

  Future<void> setId(idpr) async {
    try {
      emit(state.copyWith(id: idpr));
    } catch (e) {
      //404 product not found
      print(e);
    }
  }
}
