part of 'product_cubit.dart';

class ProductState extends Equatable {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    this.id = '0',
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) {
    return ProductState(
      id: id ?? this.id,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [id, product, isLoading, isSaving];
}
