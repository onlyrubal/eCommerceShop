import 'package:flutter/foundation.dart';
import '../providers/cart.dart';

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

  void addOrder(List<CartItem> cartProducts, double total) {
    // With add method, we add at the end of the list
    // With insert method, we add at the beginning of the list
    _items.insert(
      0,
      OrderItem(
          id: '# O-' + DateTime.now().toString(),
          orderAmount: total,
          products: cartProducts,
          orderDateTime: DateTime.now()),
    );
    notifyListeners();
  }
}
