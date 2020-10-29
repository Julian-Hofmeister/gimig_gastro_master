import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OrderItem extends StatelessWidget {
  OrderItem({this.itemName = "31. Pizza Magharita", this.itemPrice = "6,90"});

  String itemName;
  String itemPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 70,
        vertical: MediaQuery.of(context).size.width / 300,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemName,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 70,
            ),
          ),
          Text(
            itemPrice,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 70,
            ),
          ),
        ],
      ),
    );
  }
}
