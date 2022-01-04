import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/drawer.dart';

import '../provider/orders.dart';
import '../widgets/order_item_view.dart';

class OrderScreen extends StatelessWidget {
  static final route = '/order-screen';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetData(),
            builder: (ctx, dataSnap) {
              if (dataSnap.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (dataSnap.error != null) {
                return Center(
                  child: Text('An Error occured!'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (context, index) =>
                            OrderItemView(orderData.orders[index])));
              }
            }));
  }
}
