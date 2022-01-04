import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './provider/cart.dart';
import './provider/products.dart';
import './screens/product_detail.dart';
import './screens/product_overview_screen.dart';
import './provider/orders.dart';
import './screens/order_screen.dart';
import '../screens/user_products_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/auth_screen.dart';
import '../provider/auth.dart';
import './screens/splachscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products([], null, null),
          update: (ctx, auth, previousProducts) => Products(
              previousProducts == null ? [] : previousProducts.items,
              auth.userId,
              auth.token),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders([], null, null),
          update: (ctx, auth, previousOrders) => Orders(
              previousOrders == null ? [] : previousOrders.orders,
              auth.userId,
              auth.token),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          routes: {
            '/': (ctx) => auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.autoLogging(),
                    builder: (ctx, authResSnap) =>
                        authResSnap.connectionState == ConnectionState.waiting
                            ? SplachScreen()
                            : AuthScreen()),
            ProductOverviewScreen.route: (ctx) => ProductOverviewScreen(),
            ProductDetail.route: (ctx) => ProductDetail(),
            CartScreen.route: (ctx) => CartScreen(),
            OrderScreen.route: (ctx) => OrderScreen(),
            UserProductsScreen.route: (ctx) => UserProductsScreen(),
            EditProductScreen.route: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
