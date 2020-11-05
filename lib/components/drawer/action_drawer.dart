import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/components/elements/custom_loading_indicator.dart';
import 'package:gimig_gastro_master/components/elements/order_item.dart';

class ActionDrawer extends StatefulWidget {
  static const String id = "order_drawer";
  ActionDrawer({this.tableNumber});

  final int tableNumber;

  @override
  _ActionDrawerState createState() => _ActionDrawerState();
}

class _ActionDrawerState extends State<ActionDrawer> {
  final _firestore = Firestore.instance
      .collection("restaurants")
      .document("venezia")
      .collection("tables");

  String message;
  bool choosen = false;

  // SENDING MESSAGE
  // TODO ADD ERROR MESSAGE
  Future sendMessage() async {
    // RETURN TO HOMESCREEN
    Navigator.pop(context);

    //SEND MESSAGE
    await _firestore
        .document("${widget.tableNumber}")
        .collection("messages")
        .add({"message": message});

    print("sending message");
  }

  @override
  Widget build(BuildContext context) {
    // TODO ADD ERROR MESSAGE
    return StreamBuilder<QuerySnapshot>(
      //STREAM
      stream: _firestore
          .document("${widget.tableNumber}")
          .collection("orders")
          .orderBy("timestamp")
          .snapshots(),
      builder: (context, snapshot) {
        // ON ERROR
        if (!snapshot.hasData) {
          return CustomLoadingIndicator();
        }

        // ITEM LISTS
        List<Widget> food = [];
        List<Widget> beverages = [];
        List<Widget> completeOrder = [];

        // CREATE ORDER ITEM
        final item = snapshot.data.documents;
        for (var item in item) {
          final itemName = item.data['name'];
          final itemPrice = item.data['price'];
          final itemAmount = item.data['amount'];
          final isFood = item.data['isFood'];

          final inProgress = item.data['inProgress'];
          final isPaid = item.data['isPaid'];

          final order = OrderItem(
            itemName: itemName,
            itemPrice: itemPrice,
            itemAmount: itemAmount,
            inProgress: inProgress,
          );

          // SORT ORDER
          if (isFood == true && inProgress == false) {
            food.insert(0, order);
          } else if (isFood == false && inProgress == false) {
            beverages.insert(0, order);
          } else if (isPaid == false) {
            print("insert $order in complete Order");

            completeOrder.insert(0, order);
          }
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 1,
          child: Stack(
            children: [
              ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nachricht",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02,
                            letterSpacing: 1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.04,
                            height: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.green.withOpacity(0),
                            child: Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: MediaQuery.of(context).size.width * 0.02,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Center(
                    child: Text(
                      "Tisch ${widget.tableNumber}",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (message == "message1") {
                                        message = "";
                                      } else {
                                        message = "message1";
                                        choosen = true;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 3,
                                          blurRadius: 8,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Text(
                                            "Guten Appetit",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 3,
                                              color: message == "message1"
                                                  ? Colors.deepOrangeAccent
                                                  : Colors.deepOrangeAccent
                                                      .withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                            decoration: BoxDecoration(
                                              color: message == "message1"
                                                  ? Colors.deepOrangeAccent
                                                  : Colors.white.withOpacity(0),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: Divider(),
                                ),
                                if (completeOrder.isNotEmpty)
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Bestellt:",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.015,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              0.007),
                                      Column(
                                        children: completeOrder,
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(15)),
                  ),
                  // margin: EdgeInsets.only(bottom: 35),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.08,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.all(Radius.circular(30)),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black.withOpacity(0.1),
                  //       spreadRadius: 3,
                  //       blurRadius: 10,
                  //       offset: Offset(0, 3), // changes position of shadow
                  //     ),
                  //   ],
                  // ),
                  child: FlatButton(
                      color: message == "message1"
                          ? Colors.deepOrangeAccent
                          : Colors.deepOrangeAccent.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(15)),
                      ),
                      child: Text(
                        "Nachricht Senden",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 70,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () {
                        sendMessage();
                      }),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
