import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  ListItem(
      {this.name, this.amount, this.price, this.accepted = false, this.id});

  final String name;
  final int amount;
  final String price;
  final bool accepted;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Opacity(
            opacity: accepted == false ? 1 : 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name),
                SizedBox(width: 50),
                Text("${amount.toString()}x"),
                Text(price)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
