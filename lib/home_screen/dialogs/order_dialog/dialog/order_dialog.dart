import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/home_screen/components/loading_indicator/custom_loading_indicator.dart';
import 'package:gimig_gastro_master/home_screen/dialogs/order_dialog/services/accept_order_service.dart';

import '../components/list_item/list_item.dart';

class OrderDialog extends StatefulWidget {
  OrderDialog({this.status, this.tableNumber});

  final String status;
  final String tableNumber;

  final _firestore = FirebaseFirestore.instance
      .collection('restaurants')
      .doc("${FirebaseAuth.instance.currentUser.email}")
      .collection('tables');

  @override
  _OrderDialogState createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  bool allOrders = false;
  AcceptOrderService orderService = AcceptOrderService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //STREAM
      stream: widget._firestore
          .doc("${widget.tableNumber}")
          .collection("orders")
          .orderBy("timestamp")
          .snapshots(),
      builder: (context, snapshot) {
        // ON ERROR
        if (!snapshot.hasData) {
          return CustomLoadingIndicator();
        }

        // ITEM LISTS
        List<Widget> completeFood = [];
        List<Widget> completeBeverages = [];
        List<Widget> beverages = [];
        List<Widget> food = [];

        final snapshotItem = snapshot.data.docs;

        // CREATE ORDERITEM
        for (var item in snapshotItem) {
          final itemName = item.data()['name'];
          final itemPrice = item.data()['price'];
          final itemAmount = item.data()['amount'];
          final isFood = item.data()['isFood'];
          final id = item.id;

          final inProgress = item.data()['inProgress'];
          // final isPaid = item.data()['isPaid'];

          final order = ListItem(
            name: itemName,
            price: itemPrice,
            amount: itemAmount,
            accepted: inProgress,
            id: id,
          );

          if (isFood == true && inProgress == false) {
            food.insert(0, order);
          } else if (isFood == false && inProgress == false) {
            beverages.insert(0, order);
          } else if (isFood == true && inProgress == true) {
            print("insert $order in complete Order");
            completeFood.insert(0, order);
          } else if (isFood == false && inProgress == true) {
            print("insert $order in complete Order");
            completeBeverages.insert(0, order);
          }
        }
        return AlertDialog(
          elevation: 0,
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Color(0xFFeeeeee),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TISCH ${widget.tableNumber}",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                          Row(
                            children: [
                              Text(
                                "Alle Bestellungen",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 10),
                              Switch(
                                value: allOrders,
                                onChanged: (value) {
                                  setState(() {
                                    allOrders = value;
                                    print(allOrders);
                                  });
                                },
                                activeTrackColor: Colors.greenAccent,
                                activeColor: Colors.greenAccent,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.35 - 48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Getränke",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 425,
                                    child: ListView(
                                      children: [
                                        Column(
                                          children: beverages,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        if (allOrders == true)
                                          Column(children: completeBeverages),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            VerticalDivider(
                              // endIndent: 200,
                              indent: 0,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.35 - 48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Speisen",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 425,
                                    child: ListView(
                                      children: [
                                        Column(
                                          children: food,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        if (allOrders == true)
                                          Column(children: completeFood),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 70,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20)),
                              color: Color(0xFF41C981),
                            ),
                            child: Center(
                                child: Text(
                              "Getränke Annehmen",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                          onTap: () {
                            orderService.acceptBeverages(
                                beverages: beverages,
                                context: context,
                                tableNumber: widget.tableNumber);
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20)),
                              color: Color(0xFFEE7853),
                            ),
                            child: Center(
                                child: Text(
                              "Gesamte Bestellung Annehmen",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                          onTap: () {
                            orderService.acceptOrder(
                                food: food,
                                beverages: beverages,
                                context: context,
                                tableNumber: widget.tableNumber);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
