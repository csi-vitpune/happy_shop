import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';

class ProductDetail extends StatelessWidget {
  static final route = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: ,
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title, textAlign: TextAlign.center,),
              background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          SliverList(

            delegate: SliverChildListDelegate(
                [
              SizedBox(
                height: 10,
              ),
              Text(
                loadedProduct.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,

                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                loadedProduct.description,
                softWrap: true,
              ),
              SizedBox(height: 800,)
            ]),
          ),
        ],
      ),
    );
  }
}
