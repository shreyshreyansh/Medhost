import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders_provider.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

void main() => runApp(MyApp());

// The ChangeNotifierProvider widget offers an intersting constructor .value
// which takes a value argument to do the same thing it does now
// this is used only if we know that the context is redundant in nature
// and we can do without it or we may also (_) do a syntax like this
// to represent tht the context was never actually needed
// *** IMPORTANT ***
// the value contructor is recommeneded to be used while using ListView or GridView
// what happens is that if we use the normal constructor with the grid or list
// view then for large number of information the widgets are recycled and hence
// they result in strange bugs and weird behaviours although we use the normal
// constructor over here because the normal constructor is recommended to use the normal
// constructor when we are instantiating a new class as it is better

// Simply put when reusing a widget use the .value constructoe and when
// instatiating a new object be sure to use the normal constructor
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          accentColor: Colors.deepOrange,
          primarySwatch: Colors.purple,
        ),
        home: ProductOverview(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
