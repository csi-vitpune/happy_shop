import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/screens/product_detail.dart';

import '../provider/product.dart';
import '../provider/auth.dart';

class ProductIteam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetail.route, arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          )


        ),
        footer: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridTileBar(
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                  icon: Icon(product.isFavorites
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: ()async {
                    try{
                      await product.toggleIsFavorites(auth.token, auth.userId);
                    }
                    catch(error){
                      scaffold.showSnackBar(SnackBar(content: Text('Some went wrong...'),));
                    }

              },
                  color: Theme.of(context).accentColor),
            ),
            trailing: Consumer<Cart>(
              builder: (_, cart, ch) => IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => {
                  cart.addItem(
                      productId: product.id,
                      title: product.title,
                      price: product.price),
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Item added to cart'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeCartItem(product.id);
                      },
                    ),
                  ))
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
