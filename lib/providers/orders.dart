import 'package:flutter/foundation.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double orderAmount;
  final List<CartItem> products;
  final DateTime orderDateTime;

  OrderItem({
    @required this.id,
    @required this.orderAmount,
    @required this.products,
    @required this.orderDateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const ordersURL =
        'https://ecommerceshopapp-95907.firebaseio.com/orders.json';
    final dateTimeStamp = DateTime.now();

    try {
      final response = await http.post(
        ordersURL,
        body: json.encode(
          {
            'orderAmount': total,
            'orderDateTime': dateTimeStamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          },
        ),
      );

      // With add method, we add at the end of the list
      // With insert method, we add at the beginning of the list
      _items.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          orderAmount: total,
          products: cartProducts,
          orderDateTime: dateTimeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchOrders() async {
    const orderURL =
        'https://ecommerceshopapp-95907.firebaseio.com/orders.json';
    try {
      final response = await http.get(orderURL);
      // Temporary List of Products
      final List<OrderItem> _loadedOrders = [];

      // print(response.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) return;

      // Iterating over extractedData and saving that data in loadedOrders list.
      extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(
          OrderItem(
            id: orderId,
            orderAmount: orderData['orderAmount'],
            orderDateTime: DateTime.parse(orderData['orderDateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((cartItem) => CartItem(
                      id: cartItem['id'],
                      price: cartItem['price'],
                      quantity: cartItem['quantity'],
                      title: cartItem['title'],
                    ))
                .toList(),
          ),
        );
      });
      // Setting actual List of Product Items to fetched temporary list of loadedProducts
      _items = _loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
