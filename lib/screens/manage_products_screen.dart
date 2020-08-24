import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/manage_product_item.dart';
import '../screens/edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  static final routeName = 'manage-products';
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Products',
          style: Theme.of(context).textTheme.headline2,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: new IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Count of Products',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Chip(
                            label: Text(
                              '${products.items.length}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            backgroundColor:
                                Theme.of(context).buttonColor.withAlpha(200),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return ManageProductItem(
                        title: products.items[index].title,
                        imageUrl: products.items[index].imageUrl,
                        id: products.items[index].id,
                        price: products.items[index].price,
                      );
                    },
                    itemCount: products.items.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
