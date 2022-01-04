import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';

class CartViewItem extends StatelessWidget {
  CartItem cart;
  String productId;

  CartViewItem(this.cart, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cart.cartId),
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: EdgeInsets.all(10),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (directon) {
        Provider.of<Cart>(context, listen: false).removeCartItem(productId);
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
                child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: FittedBox(
                child: Text("\$${cart.price}"),
              ),
            )),
            title: Text(
              cart.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Total : \$${(cart.price * cart.quantity)}'),
            trailing: Text('x ${cart.quantity}'),
          ),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('You wnat to delete the iteam form cart?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('No')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('Yes'))
                  ],
                ));
      },
    );
  }
}
