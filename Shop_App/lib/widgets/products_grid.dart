import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_provider.dart';

// The Provider.of() sets up an internal connection with the inherited
// widget and hence to call the .of() method we must make sure that
// the class in whic this method is called is directly or indirectly
// attached to the class in which we create the provider

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProduct =
        showFavs ? productsData.favouriteItem : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProduct.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        child: ProductItem(
            // id: loadedProduct[i].id,
            // title: loadedProduct[i].title,
            // imageUrl: loadedProduct[i].imageUrl,
            ),
        value: loadedProduct[i],
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
// Check out the mixins lecture for a deep dive on how dart deals with
// polymorphism
