import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/components/drawer/order_drawer.dart';

// ignore: must_be_immutable
class TableCard extends StatelessWidget {
  TableCard({this.tableNumber});

  String tableNumber;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return OrderDrawer(
              tableNumber: tableNumber,
            );
          },
        );
        print("click");
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.width / 5,
        margin: EdgeInsets.all(MediaQuery.of(context).size.height / 60),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
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
      ),
    );
  }
}
