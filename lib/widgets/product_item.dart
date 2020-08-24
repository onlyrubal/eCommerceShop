import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_details_screen.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import 'package:flushbar/flushbar.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    // Access to cart container
    final cart = Provider.of<Cart>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
            leading: Consumer<Product>(
              builder: (context, product, _) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavoriteStatus();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Container(
              height: 20,
              child: FittedBox(
                child: Text(
                  product.title,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addItem(
                    product.id, product.price, product.title, product.imageUrl);
                //    Scaffold.of(context).hideCurrentSnackBar();
                // Scaffold.of(context).showSnackBar(SnackBar(
                //   duration: Duration(seconds: 2),
                //   content: Text(
                //     '\'${product.title}\' added to the cart',
                //     style: Theme.of(context).textTheme.subtitle2,
                //   ),
                //   backgroundColor: Colors.white,
                //   action: SnackBarAction(
                //       label: 'Undo',
                //       onPressed: () {
                //         cart.removeSingleItem(product.id);
                //       }),
                // ));
                Flushbar(
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  message: '\'${product.title}\' added to the cart',
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 28.0,
                    color: Theme.of(context).accentColor,
                  ),
                  mainButton: FlatButton(
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                    child: Text(
                      "UNDO",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                  duration: Duration(seconds: 2),
                  forwardAnimationCurve: Curves.decelerate,
                  reverseAnimationCurve: Curves.easeOut,
                )..show(context);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
