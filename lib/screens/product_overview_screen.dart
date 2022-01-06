
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/drawer.dart';

import '../widgets/product_grid.dart';
import '../widgets/badge.dart';


enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  static final route = '/product-overview-screen';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {


  var isFavSelected = false;
  var _isLoading = false;
  var _didChangedDep = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     drawer: AppDrawer(),

      appBar: AppBar(
        title: Text('Products'),
        actions: [
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                    child: ch!,
                    value: cart.itemCount.toString(),
                  ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.route);
                },
              )),
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    isFavSelected = true;
                  } else
                    isFavSelected = false;
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ])
        ],
      ),
      body: _isLoading? Center(child: CircularProgressIndicator(),):ProductGrid(isFavSelected),
    );
  }


  @override
  void didChangeDependencies() {
    if(_didChangedDep){

      setState(() {
        _isLoading=true;
      });
      Provider.of<Products>(context, listen: false).fetchAndSetData().then((_){
        setState(() {
          _isLoading=false;
          _didChangedDep=false;
        });
      });




    }

  }


}
