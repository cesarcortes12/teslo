import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teslo_shop/features/products/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:teslo_shop/features/products/presentation/cubit/product_form_cubit/product_form_cubit.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../../domain/domain.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  //late Future<void> _loadProductFuture;
  //late Product product;
  late ProductCubit productCubit = context.read<ProductCubit>();
  late ProductFormCubit productFormCubit;
  @override
  void initState() {
    super.initState();

    productCubit = context.read<ProductCubit>()..loadProduct(widget.productId);
    // _loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productCubit = context.read<ProductCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Producto'), actions: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
      ]),
      body: BlocBuilder<ProductCubit, ProductState>(
          bloc: productCubit,
          builder: (context, state) {
            if (productCubit.state.product != null) {
              productFormCubit = context.read<ProductFormCubit>()
                ..changeData(producto: productCubit.state.product!);
              return _ProductView(product: productCubit.state.product!);
            }
            return FullScreenLoader();
          }),

      //builder: (context, state) {
      /*if (productCubit.state.product != null) {
            return _ProductView(product: productCubit.state.product!);
          }
          return Text('Cargando..');
        },*/
      //),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save_as_outlined),
      ),
    );
  }
}

class _ProductView extends StatelessWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final productFormCubit = context.read<ProductFormCubit>();

    if (product == null) {
      return Center(child: CircularProgressIndicator());
    }

    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, state) {
        return ListView(
          children: [
            SizedBox(
              height: 250,
              width: 600,
              child: _ImageGallery(images: productFormCubit.state.images),
            ),
            const SizedBox(height: 10),
            Center(
                child: Text(productFormCubit.state.title.value,
                    style: textStyles.titleSmall)),
            const SizedBox(height: 10),
            _ProductInformation(product: product),
          ],
        );
      },
    );
  }
}

class _ProductInformation extends StatelessWidget {
  final Product product;

  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context) {
    final productFormCubit = context.read<ProductFormCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productFormCubit.state.title.value,
            onChanged: (value) => productFormCubit.onTitleChange(value),
            errorMessage: productFormCubit.state.title.errorMessage,
          ),
          const SizedBox(height: 15),
          CustomProductField(
            label: 'Slug',
            initialValue: productFormCubit.state.slug.value,
            onChanged: (value) => productFormCubit.onSlugChange(value),
            errorMessage: productFormCubit.state.slug.errorMessage,
          ),
          const SizedBox(height: 15),
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productFormCubit.state.price.value.toString(),
            onChanged: (value) => productFormCubit.onPriceChange(double
                    .tryParse(value) ??
                -1), //no se puede cero porque el vlaidator tiene cero o mayor
            errorMessage: productFormCubit.state.price.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text('Extras'),
          _SizeSelector(
            selectedSizes: productFormCubit.state.sizes,
            onSizesChanged: productFormCubit.onSizeChanged,
          ),
          const SizedBox(height: 5),
          _GenderSelector(
            selectedGender: productFormCubit.state.gender,
            onGenderChanged: productFormCubit.onGenderChanged,
          ),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productFormCubit.state.inStock.value.toString(),
            onChanged: (value) =>
                productFormCubit.onStockChange(int.tryParse(value) ?? -1),
            errorMessage: productFormCubit.state.inStock.errorMessage,
          ),
          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: product.description,
            onChanged: (value) => productFormCubit.onDescriptionChange(value),
          ),
          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.join(', '),
            onChanged: (value)=> productFormCubit.onTagsChange(value),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
  final void Function(List<String> selectedSizes) onSizesChanged;

  const _SizeSelector(
      {required this.selectedSizes, required this.onSizesChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10)));
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        onSizesChanged(List.from(newSelection));
        print(newSelection);
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];
  final void Function(String selectedGender) onGenderChanged;

  const _GenderSelector(
      {required this.selectedGender, required this.onGenderChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: true,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
              icon: Icon(genderIcons[genders.indexOf(size)]),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12)));
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          onGenderChanged(newSelection.first);
          print(newSelection.first);
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.isEmpty
          ? [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.asset('assets/images/no-image.jpg',
                      fit: BoxFit.cover))
            ]
          : images.map((e) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  e,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
    );
  }
}
