import 'package:flutter/material.dart';
import './product.dart';

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
}
