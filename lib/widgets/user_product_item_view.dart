import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';

import '../provider/product.dart';
import '../screens/edit_product_screen.dart';

class UserProductItemView extends StatelessWidget {
  final Product item;


  UserProductItemView(this.item);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(item.title),
      leading: CircleAvatar(backgroundImage: NetworkImage(item.imageUrl),),
      trailing: Container(

        child: Container(
          width: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
                  Navigator.of(context).pushNamed(EditProductScreen.route, arguments: item.id);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try{
                    await Provider.of<Products>(context, listen: false).removeProduct(item.id);
                  }catch(error){
                    scaffold.showSnackBar(SnackBar(content: Text(error.toString()),));
                  }

                },
                color: Theme.of(context).errorColor,
              ),


            ],
          ),
        ),
      ),
    );
  }
}
