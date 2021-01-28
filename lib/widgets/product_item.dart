import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String imageUrl;
  // final String id;
  // final String title;

  // ProductItem(
  //     {@required this.id, @required this.imageUrl, @required this.title});

  // Yet another alternate syntax for listening to data we may wrap the widgets
  // that are interested in our dynamic global data by wrapping them in the onsumer
  // widget the Consumer widget's builder takes 3 arguments builder : (contxe , var_name , child) => Widget
  // Now we may have the dynamic data accesible inside the Consumer widget by
  // accessing the name product another thing that we may do to improve our app
  // is listening only for the favourite and not listening for the provider anymore
  // while using Provider.of() the child argument that the Consumer widget defines
  // refers to a widget treethat we may define that never changes / rebuilds
  // whenever the consumer is rebuilt
  // We generally want to provide the listeners at the lowest level possible

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(null);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: Consumer(
          builder: (context, product, child) => GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              onPressed: product.toggleFavourite,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItems(product.id, product.price, product.title);
                // The omnious Scaffold.of(context) here is a familair usage of the
                // .of() method previously used to establish
                // connectiotns between background widgets here with the Scaffold.of()
                // The connection that is being made is to the nearest Scaffold Object
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content:
                      Text('Added Item To Cart', textAlign: TextAlign.center),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                ));
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
