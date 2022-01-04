import 'package:flutter/foundation.dart';

class CartItem {
  String cartId;
  String title;
  double price;
  int quantity;

  CartItem({required this.cartId,
    required this.title,
    required this.price,
    required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get items {
    return {..._item};
  }

  double get totalAmt {
    double total = 0.0;
    _item.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  int get itemCount {
    return _item.length;
  }

  void addItem({
    required String productId,
    required String title,
    required double price,
  }) {
    if (_item.containsKey(productId)) {
      _item.update(
          productId,
              (oldCartItem) =>
              CartItem(
                  cartId: oldCartItem.cartId,
                  title: oldCartItem.title,
                  price: oldCartItem.price,
                  quantity: oldCartItem.quantity + 1));
    } else {
      _item.putIfAbsent(
          productId,
              () =>
              CartItem(
                  cartId: DateTime.now().toString(),
                  title: title,
                  price: price,
                  quantity: 1));
    }
    notifyListeners();
  }

  void removeCartItem(String productId) {
    _item.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _item = {};
    notifyListeners();
  }

  void removeItem(String productId) {
    if (!_item.containsKey(productId)) return;

    if (_item[productId]!.quantity > 1) {
      _item.update(productId, (oldValue) =>
          CartItem(cartId: oldValue.cartId,
              title: oldValue.title,
              price: oldValue.price,
              quantity: oldValue.quantity - 1));
    }
    else {
      _item.remove(productId);
    }
  }
}
