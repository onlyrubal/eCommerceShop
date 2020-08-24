import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  // Map the cart with Product ID
  //key is ProductId and value is CartItem

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  // Adding Item to the Cart.
  void addItem(String productId, double price, String title, String imageUrl) {
    if (_items.containsKey(productId)) {
      //Change the quantity
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          title: existingCartItem.title,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      // Add a new product item to the cart.
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          // By Default we are adding quantity as 1.
          quantity: 1,
          title: title,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  // Getter to count the number of items in the Cart.
  int get itemInCartCount {
    int count = 0;
    _items.forEach((_, cartItem) {
      count = count + cartItem.quantity;
    });
    return count;
  }

  double get totalCartAmount {
    double sum = 0;
    _items.forEach((_, cartItem) {
      sum += cartItem.price * cartItem.quantity;
    });
    return sum;
  }

  void removeItem(String productId) {
    // Passing the key to remove the particular Map Item.
    _items.remove(productId);
    notifyListeners();
  }

// Removing Single Item from the Cart
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1) {
      // _items[productId].quantity = _items[productId].quantity - 1;
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity - 1,
            price: existingCartItem.price,
            imageUrl: existingCartItem.imageUrl),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

// Resetting or Clearing the Cart.
  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
