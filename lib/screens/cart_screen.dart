import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../widgets/product_item_in_cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: Theme.of(context).textTheme.headline2,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: new IconThemeData(
          color: Colors.white,
        ),
        leading: new Container(),
        actions: [
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estimated Total',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Spacer(),
                        Text(
                          '(${cart.itemInCartCount} items)   ',
                          style: TextStyle(fontSize: 14),
                        ),
                        Chip(
                          label: Text(
                            '\$ ${cart.totalCartAmount.toStringAsFixed(2)}',
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
              PlaceOrderButton(cart: cart, order: order),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: SecondaryButton(
                    btnText: 'RETURN TO SHOPPING',
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: ProductItemInCart(
                    //Interested in the values of the items so that is why cart.items.values
                    id: cart.items.values.elementAt(index).id,
                    productId: cart.items.keys.elementAt(index),
                    price: cart.items.values.toList()[index].price,
                    quantity: cart.items.values.toList()[index].quantity,
                    title: cart.items.values.toList()[index].title,
                    imageUrl: cart.items.values.toList()[index].imageUrl,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceOrderButton extends StatefulWidget {
  const PlaceOrderButton({
    Key key,
    @required this.cart,
    @required this.order,
  }) : super(key: key);

  final Cart cart;
  final Orders order;

  @override
  _PlaceOrderButtonState createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<PlaceOrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: GestureDetector(
        onTap: (widget.cart.totalCartAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  //Making LoadingSpinner visible
                  _isLoading = true;
                });
                // Adding the cart items to Order
                await widget.order.addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalCartAmount,
                );

                setState(() {
                  // Resetting LoadingSpinner to false.
                  _isLoading = false;
                });

                // Clearing the Cart
                widget.cart.clearCart();
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : PrimaryButton(
                btnText: 'PLACE ORDER',
              ),
      ),
    );
  }
}
