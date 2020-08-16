import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;
import 'dart:math';

class OrderItem extends StatefulWidget {
  // This OrderItem is of OrderItem model in orders.dart not this class.
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$ ${widget.order.orderAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            subtitle: Text(
              DateFormat.yMEd()
                  .add_jms()
                  .format(widget.order.orderDateTime)
                  .toString(),
              style: Theme.of(context).textTheme.caption,
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.order.products.length * 25.0 + 40, 180.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.order.products.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.order.products[index].title,
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.left,
                            ),
                            Spacer(),
                            Text('${widget.order.products[index].quantity} x ',
                                style: Theme.of(context).textTheme.caption),
                            SizedBox(width: 10),
                            Text('\$ ${widget.order.products[index].price} ',
                                style: Theme.of(context).textTheme.subtitle2),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
