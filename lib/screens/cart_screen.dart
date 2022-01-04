import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../widgets/cart_view_item.dart';
import '../provider/orders.dart';

class CartScreen extends StatefulWidget {
  static final route = '/cart-screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading= false;
  @override
  Widget build(BuildContext context) {
    final scaffold  = ScaffoldMessenger.of(context);
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmt.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                      onPressed: cart.totalAmt<=0? null : () async{
                        setState(() {
                          _isLoading=true;
                        });
                        try{
                          await Provider.of<Orders>(context, listen: false)
                              .addOrder(cartItems.values.toList(), cart.totalAmt);
                          cart.clearCart();
                        }
                        catch(error){
                          scaffold.showSnackBar(SnackBar(content: Text('Some thing went wrong')));
                        }
                        setState(() {
                          _isLoading=false;
                        });

                      },
                      child: _isLoading? Center(child: CircularProgressIndicator(), ):Text(
                        'Order Now!',
                        style: TextStyle(color: cart.totalAmt<=0? Colors.grey :Theme.of(context).primaryColor),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctc, index) => CartViewItem(
                    cartItems.values.toList()[index],
                    cartItems.keys.toList()[index])),
          ),
        ],
      ),
    );
  }
}
