import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favourite,
  All,
}
// The popup Menu is a different type of widget that gives us a pop up menu
// the value that is passed to on selected is nothing but the value that the
// popupMenuItem gives back we use enums here because using in 0/1 can be cryptic
// and uniformative in nature

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool _showonlyFav = false;
  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourite) {
                  _showonlyFav = true;
                } else {
                  _showonlyFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: FilterOptions.Favourite),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, child) => Badge(
              child: child,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showonlyFav),
    );
  }
}
