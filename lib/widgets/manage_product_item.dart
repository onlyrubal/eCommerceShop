import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ManageProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  final double price;

  ManageProductItem({this.title, this.imageUrl, this.id, this.price});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onTap: () {
          // Pushing to the new edit product screen.
          Navigator.of(context)
              .pushNamed(EditProductScreen.routeName, arguments: id);
        },
        child: Dismissible(
          direction: DismissDirection.endToStart,
          key: ValueKey(id),
          background: Container(
            color: Theme.of(context).errorColor,
            child: Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 40,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerRight,
          ),
          onDismissed: (dismissDirection) async {
            try {
              await Provider.of<Products>(context, listen: false)
                  .removeProductFromInventory(id);
            } catch (error) {
              scaffold.showSnackBar(
                SnackBar(
                  content: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          },
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                  Text(title),
                  Text('\$ ${price.toString()}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
