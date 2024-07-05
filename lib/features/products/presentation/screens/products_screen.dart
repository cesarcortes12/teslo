import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/presentation/cubit/products_cubit/products_cubit.dart';
import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        context.read<ProductsCubit>().loadNextPage();
      }
    });
    //TODO: infinite scroll pending
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return Scaffold(
          drawer: SideMenu(scaffoldKey: scaffoldKey),
          appBar: AppBar(
            title: const Text('Products'),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.search_rounded))
            ],
          ),
          body: _ProductsView(scrollController: scrollController),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text('Nuevo producto'),
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        );
      },
    );
  }
}

class _ProductsView extends StatelessWidget {
  final ScrollController scrollController;
  const _ProductsView({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final productsState = context.watch<ProductsCubit>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          final product = productsState.products[index];
          return GestureDetector(
              onTap: () => context.push('/product/${product.id}'),
              child: ProductCard(product: product));
        },
      ),
    );
  }
}
