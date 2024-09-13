import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/enviroments.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/cubit/product_cubit/product_cubit.dart';

import '../../../../shared/infraestructure/inputs/inputs.dart';

part 'product_form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  //final void Function(Map<String, dynamic> productLike)? onSubmitCallback;
  final ProductsRepository productsRepository;
  final ProductCubit productsCubit;

  ProductFormCubit(
      {required this.productsRepository, required this.productsCubit})
      : super(const ProductFormState());

  Future<bool> onFormSubmit() async {
    _touchEverything();

    if (!state.isFormValid) return false;

    //if (onSubmitCallback == null) return false;

    final productLike = {
      'id': state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'Stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images
          .map((image) =>
              image.replaceAll('${Enviroment.apiUrl}/files/product/', ''))
          .toList()
    };

    return true;
    //TODO LLAMAR ONSUBMIT CALLBACK
  }

  void _touchEverything() {
    emit(state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.inStock.value),
    ])));
  }

  void onTitleChange(String value) {
    emit(state.copyWith(
        title: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ])));
  }

  void onSlugChange(String value) {
    emit(state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ])));
  }

  void onPriceChange(double value) {
    emit(state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.inStock.value),
        ])));
  }

  void onStockChange(int value) {
    emit(state.copyWith(
        inStock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value),
        ])));
  }

  void onSizeChanged(List<String> sizes) {
    emit(state.copyWith(sizes: sizes));
  }

  void onGenderChanged(String gender) {
    emit(state.copyWith(gender: gender));
  }

  void onDescriptionChange(String description) {
    emit(state.copyWith(description: description));
  }

  void onTagsChange(String tags) {
    emit(state.copyWith(tags: tags));
  }

  void changeData(
      {required Product producto}) {
    emit(state.copyWith(
        id: producto.id,
        title: Title.dirty(producto.title),
        slug: Slug.dirty(producto.slug),
        price: Price.dirty(producto.price),
        inStock: Stock.dirty(producto.stock),
        gender: producto.gender,
        description:producto. description,
        tags: producto.tags.join(','),
        images: producto.images));
  }
}
