import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/http_error.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // )
  ];

  String? userId;

  String? authToken;


  Products( this._items, this.userId,  this.authToken);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorites).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(Product product) async{
    if(product.id.isNotEmpty){
      try{
        String link = 'https://shopapp-b4828-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken';
        final url = Uri.parse(link);

        await http.patch(url, body: json.encode({
          'title' : product.title,
          'description' :product.description,
          'price' : product.price,
          'imageUrl' : product.imageUrl,

        }));


        var index =_items.indexWhere((item) => item.id==product.id);
        _items[index] = product;

      }
      catch(error){
        throw error;
      }

    }
  }

  Future<void> fetchAndSetData([bool byCreator = false]) async{
    String filter = byCreator? '&orderBy="creatorId"&equalTo="$userId"' : '';
    String link = 'https://shopapp-b4828-default-rtdb.firebaseio.com/products.json?auth=$authToken$filter';

    var url = Uri.parse(link);
    try{
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if(data==null){
        _items=[];
        notifyListeners();
        return;
      }
      link = 'https://shopapp-b4828-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      url = Uri.parse(link);
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body) as Map<String, dynamic>;

      final List<Product> loadedProducts =[];
      data.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          isFavorites: favData==null? false : favData['productId'] ?? false
        ));
      });
      _items = loadedProducts;
      notifyListeners();


    }
    catch(error){

    }
  }

  Future<void> addProduct(Product product) async {


    final url = Uri.parse('https://shopapp-b4828-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try{
     final response =  await http.post(url, body: json.encode({
        'title' : product.title,
        'description' :product.description,
        'price' : product.price,
        'imageUrl' : product.imageUrl,
       'creatorId' : userId,
        'isFavorites': product.isFavorites
      }));

      _items.add(Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl));

      notifyListeners();

    }
     catch(error){
      print(error.toString());
      throw error;
    }

  }

  Future<void> removeProduct(String id) async{
    if(!id.isEmpty){
      final url = Uri.parse('https://shopapp-b4828-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      var index = _items.indexWhere((element) => element.id==id);
      Product? product = _items[index];
      try{
        await http.delete(url);
          _items.removeWhere((element) => element.id==id);
          product=null;
          notifyListeners();

      }catch(error){
        _items.insert(index, product!);
        throw HttpError('Failed to Delete!');
      }



    }
  }
}
