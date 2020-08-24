import 'package:flutter/material.dart';
import 'package:myshop_app/screens/manage_products_screen.dart';
import '../screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'Merchandise Shop',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            // It never adds the back button.
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop_two),
            title: Text(
              'Products',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'My Orders',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                OrderScreen.routeName,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.mode_edit),
            title: Text(
              'Manage Products',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                ManageProductsScreen.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}
