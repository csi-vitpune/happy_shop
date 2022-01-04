import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/product_iteam.dart';

import '../provider/products.dart';

class ProductGrid extends StatelessWidget {
  final bool isFavSelected;

  ProductGrid(this.isFavSelected);

  @override
  Widget build(BuildContext context) {
    final providerObject = Provider.of<Products>(context);
    final productItems = isFavSelected? providerObject.favItems : providerObject.items;

    return GridView.builder(
        itemCount: productItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) =>
            ChangeNotifierProvider.value(
                value: productItems[index],
                child: ProductIteam()));
  }
}
