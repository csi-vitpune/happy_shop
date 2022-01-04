import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/widgets/drawer.dart';
import '../provider/products.dart';
import '../widgets/user_product_item_view.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static final route = '/ser-produce-screen';

  Future<void> _refreshScreen(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.route);
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: _refreshScreen(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshScreen(context),
                    child: Consumer<Products>(
                      builder: (ctx, products, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: products.items.length,
                            itemBuilder: (context, index) =>
                                UserProductItemView(products.items[index])),
                      ),
                    ),
                  ),
      ),
    );
  }
}
