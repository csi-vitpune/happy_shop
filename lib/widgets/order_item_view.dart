import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:shop_app/provider/orders.dart';

class OrderItemView extends StatefulWidget {
  final OrderItems item;

  OrderItemView(this.item);

  @override
  State<OrderItemView> createState() => _OrderItemViewState();
}

class _OrderItemViewState extends State<OrderItemView> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.item.amount}'),
          subtitle: Text(
              DateFormat('dd/MM/yyy  @  hh:mm').format(widget.item.whenPlaced)),
          trailing: IconButton(
            icon:
                _isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(
              minHeight: _isExpanded ? 0 : 0,
              maxHeight: _isExpanded
                  ? min(widget.item.products.length * 20.0 + 10, 180)
                  : 0),
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: widget.item.products.map((e) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.title),
                  Spacer(),
                  Text('X${e.quantity}    \$${e.price}'),
                  SizedBox(
                    height: 3,
                  )
                ],
              );
            }).toList(),
          ),
        )
      ]),
    );
  }
}
