import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static final routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoadingSpinner = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      //Setting up the loading spinner
      setState(() {
        _isLoadingSpinner = true;
      });

      //Fetch the orders
      await Provider.of<Orders>(context, listen: false).fetchOrders();

      //Stopping the loading spinner.
      setState(() {
        _isLoadingSpinner = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
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
            onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoadingSpinner
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Orders',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Chip(
                              label: Text(
                                '${orders.items.length} orders',
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
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orders.items.length,
                      itemBuilder: (ctx, index) =>
                          OrderItem(orders.items[index]),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
