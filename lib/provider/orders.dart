import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../provider/cart.dart';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime whenPlaced;

  OrderItems(
      {required this.id,
      required this.amount,
      required this.products,
      required this.whenPlaced});
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];

  String? authToken;

  String? userId;


  Orders(this._orders,this.userId, this.authToken);

  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetData() async {
    final url = Uri.parse(
        'https://shopapp-b4828-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        _orders = [];
        notifyListeners();
        return;
      }

      final List<OrderItems> loadedItems = [];
      extractedData.forEach((orderId, orderData) {
        loadedItems.add(OrderItems(
            id: orderId,
            amount: orderData['amount'],
            products:(orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    cartId: item['cartId'],
                    price: item['price'],
                    title: item['title'],
                    quantity: item['quantity']))
                .toList(),
            whenPlaced: DateTime.parse(orderData['whenPlaced'])));
      });
      _orders = loadedItems.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }

  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shopapp-b4828-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'whenPlaced': timeStamp.toIso8601String(),
            'products': [
              ...cartProducts
                  .map((item) => {
                        'cartId': item.cartId,
                        'title': item.title,
                        'price': item.price,
                        'quantity': item.quantity
                      })
                  .toList()
            ]
          }));

      _orders.insert(
          0,
          OrderItems(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProducts,
              whenPlaced: timeStamp));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
