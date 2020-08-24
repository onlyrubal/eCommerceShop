import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  // Not Final because it can be changable.
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Navie Hoodie',
      description: 'A red shirt - it is pretty red!',
      price: 69.99,
      imageUrl:
          'https://cdn.shopify.com/s/files/1/0714/1079/products/david-dobrik-merch-david-dobrik-navy-tonal-clickbait-hoodie-hoodie-15110969557101_2048x.jpg?v=1592581988',
    ),
    Product(
        id: 'p2',
        title: 'Sweatpants',
        description: 'A nice pair of sweatpants.',
        price: 59.99,
        imageUrl:
            'https://cdn.shopify.com/s/files/1/0714/1079/products/david-dobrik-merch-david-dobrik-blue-cloud-sweatpants-sweatpants-15304008532077_2048x.jpg?v=1594388880'),
  ];

  List<Product> showFavoriteProducts() {
    return _items.where((_productItem) => _productItem.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  void removeProductFromInventory(String productId) {
    _items.removeWhere((productItem) => productItem.id == productId);
    notifyListeners();
  }

  void addNewProduct(Product product) {
    final newProduct = Product(
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      title: product.title,
      id: DateTime.now().toString(),
    );

    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String productId, Product newProduct) {
    // Finding the index of product in list of products.
    final productIndex =
        _items.indexWhere((product) => product.id == productId);

    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
