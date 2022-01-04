

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_error.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorites;

  Product(
      {required this.id,
        required this.title,
        required this.description,
        required this.price,
        required this.imageUrl,
        this.isFavorites=false});

  Future<void> toggleIsFavorites(String? authToken, String? userId) async{
    final url = Uri.parse('https://shopapp-b4828-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');
    try{
      final response = await http.patch(url, body: json.encode({
        'isFavorites' : !isFavorites,
      }));
      isFavorites=!isFavorites;
      if(response.statusCode>=400){
        throw HttpError('Check your Internet');
      }
      notifyListeners();
    }
    catch(error){
      throw error;

    }
    notifyListeners();

  }
}