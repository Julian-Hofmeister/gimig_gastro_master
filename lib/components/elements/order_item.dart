import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OrderItem extends StatelessWidget {
  OrderItem({
    this.itemName = "31. Pizza Magharita",
    this.itemPrice = "6,90",
    this.itemAmount,
    this.inProgress = false,
  });

  String itemName;
  String itemPrice;
  int itemAmount;
  bool inProgress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal:
        //     inProgress == false ? MediaQuery.of(context).size.width / 70 : 0,
        vertical: MediaQuery.of(context).size.width / 300,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // color: Colors.green,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(
              itemName,
              style: TextStyle(
                fontSize: inProgress == false
                    ? MediaQuery.of(context).size.width / 70
                    : MediaQuery.of(context).size.width / 80,
                color: inProgress == false ? Colors.black : Colors.black54,
              ),
            ),
          ),
          Container(
            // color: Colors.green,
            width: MediaQuery.of(context).size.width * 0.03,
            child: Text(
              "${itemAmount}x",
              style: TextStyle(
                fontSize: inProgress == false
                    ? MediaQuery.of(context).size.width / 70
                    : MediaQuery.of(context).size.width / 80,
                color: inProgress == false ? Colors.black : Colors.black54,
              ),
            ),
          ),
          Container(
            // color: Colors.green,
            width: MediaQuery.of(context).size.width * 0.048,
            child: Text(
              itemPrice,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: inProgress == false
                    ? MediaQuery.of(context).size.width / 70
                    : MediaQuery.of(context).size.width / 80,
                color: inProgress == false ? Colors.black : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
