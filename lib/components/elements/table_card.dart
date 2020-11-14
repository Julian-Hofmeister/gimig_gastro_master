import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TableCard extends StatelessWidget {
  TableCard({this.tableNumber, this.status});

  String tableNumber;
  String status;

  Color checkStatus() {
    print("TABLENUMBER: $tableNumber WITH STATUS: $status");
    if (status == "ordered") {
      return Colors.redAccent;
    } else if (status == "payRequest") {
      return Colors.blueAccent;
    } else if (status == "accepted") {
      return Colors.white.withOpacity(0);
    } else {
      return Colors.white.withOpacity(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width / 5,
      margin: EdgeInsets.all(MediaQuery.of(context).size.height / 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        border: Border.all(color: checkStatus().withOpacity(0.6), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tisch ",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 55,
            ),
          ),
          Text(
            "$tableNumber",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
    );
  }
}
