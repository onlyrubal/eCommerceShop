import 'package:flutter/material.dart';
import 'package:myshop_app/providers/cart.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class ProductItemInCart extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  ProductItemInCart(
      {this.id,
      this.productId,
      this.price,
      this.quantity,
      this.title,
      this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      // It needs any unique key and since CartId is unique, so we wrote it.
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 60,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerRight,
      ),
      onDismissed: (direction) {
        // Remove the Cart Product Item in the Cart.
        cart.removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 200,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 190,
                            height: 26,
                            child: FittedBox(
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ),
                          Text(
                            '\$ ${price.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Text('$quantity x'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Total',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '\$ ${(price * quantity).toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
