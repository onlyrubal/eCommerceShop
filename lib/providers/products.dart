import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

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

  Future<void> toggleFavoriteStatus() async {
    // Optimistic Updating
    final oldIsFavoriteStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    final productURL =
        'https://ecommerceshopapp-95907.firebaseio.com/products/$id.json';

    final response = await http.patch(
      productURL,
      body: json.encode(
        {
          'isFavorite': isFavorite,
        },
      ),
    );

    if (response.statusCode >= 400) {
      isFavorite = oldIsFavoriteStatus;
      notifyListeners();
      throw HttpException(errorMessage: 'Error Changing Fav Status');
    }
  }
}

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Navie Hoodie',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 69.99,
    //   imageUrl:
    //       'https://cdn.shopify.com/s/files/1/0714/1079/products/david-dobrik-merch-david-dobrik-navy-tonal-clickbait-hoodie-hoodie-15110969557101_2048x.jpg?v=1592581988',
    // ),
    // Product(
    //     id: 'p2',
    //     title: 'Sweatpants',
    //     description: 'A nice pair of sweatpants.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://cdn.shopify.com/s/files/1/0714/1079/products/david-dobrik-merch-david-dobrik-blue-cloud-sweatpants-sweatpants-15304008532077_2048x.jpg?v=1594388880'),
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

  Future<void> removeProductFromInventory(String productId) async {
    final productURL =
        'https://ecommerceshopapp-95907.firebaseio.com/products/$productId';

    // Getting the index of the product
    final existingProductIndex =
        _items.indexWhere((product) => product.id == productId);

    // Pointer to the particular product through productIndex.
    // We need this pointer to the memory for error case
    var existingProduct = _items[existingProductIndex];

    // Removing product from local memory, we can wait for confirmation later.
    _items.removeAt(existingProductIndex);
    notifyListeners();

    // Removing product from Firebase Database
    final response = await http.delete(productURL);
    //print(response.statusCode);

    if (response.statusCode >= 400) {
      // Rolling back the removal (incase of an error)
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(errorMessage: 'Cannot delete the product');
    }
    // If delete is successfull, then point the existing product to null.
    existingProduct = null;
  }

  Future<void> addNewProduct(Product product) async {
    const productsURL =
        'https://ecommerceshopapp-95907.firebaseio.com/products.json';

    try {
      // POST Request for saving the products
      final response = await http.post(
        productsURL,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchProducts() async {
    const productURL =
        'https://ecommerceshopapp-95907.firebaseio.com/products.json';
    try {
      final response = await http.get(productURL);
      //print(response.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      // Temporary List of Products
      final List<Product> _loadedProducts = [];

      extractedData.forEach((productId, productData) {
        _loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ));
      });
      // Setting actual List of Product Items to fetched temporary list of loadedProducts
      _items = _loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    // Finding the index of product in list of products.
    final productIndex =
        _items.indexWhere((product) => product.id == productId);

    if (productIndex >= 0) {
      try {
        // changed to final because of runtime.
        final productURL =
            'https://ecommerceshopapp-95907.firebaseio.com/products/$productId.json';
        await http.patch(
          productURL,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }),
        );
        // Updating the product in local memory
        _items[productIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }
}
