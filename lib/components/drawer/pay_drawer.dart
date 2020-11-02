import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/components/elements/order_item.dart';

class PayDrawer extends StatefulWidget {
  static const String id = "order_drawer";
  PayDrawer({this.tableNumber});

  final int tableNumber;

  @override
  _PayDrawerState createState() => _PayDrawerState();
}

class _PayDrawerState extends State<PayDrawer> {
  final _firestore = Firestore.instance;

  Future acceptPayRequest({food, beverages}) async {
    setState(
      () async {
        print("pay request accepted");
        Navigator.pop(context);

        //UPDATE STATUS
        await Firestore.instance
            .collection('restaurants')
            .document('venezia')
            .collection('tables')
            .document("${widget.tableNumber}")
            .updateData({"status": "paid"});

        // CHECK AS PAID
        QuerySnapshot querySnapshot = await Firestore.instance
            .collection('restaurants')
            .document('venezia')
            .collection('tables')
            .document("${widget.tableNumber}")
            .collection("orders")
            .getDocuments();

        for (int i = 0; i < querySnapshot.documents.length; i++) {
          var item = querySnapshot.documents[i].documentID;
          print(item);
          await Firestore.instance
              .collection('restaurants')
              .document('venezia')
              .collection('tables')
              .document("${widget.tableNumber}")
              .collection("orders")
              .document("$item")
              .updateData({"isPaid": true});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
        color: Colors.white,
      ),
      // padding: EdgeInsets.symmetric(
      //     horizontal: MediaQuery.of(context).size.height / 50),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("restaurants")
            .document("venezia")
            .collection("tables")
            .document("${widget.tableNumber}")
            .collection("orders")
            .orderBy("timestamp")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
              ),
            );
          }
          final item = snapshot.data.documents;
          List<Widget> food = [];
          List<Widget> beverages = [];
          List<Widget> completeOrder = [];
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

            if (isFood == true && inProgress == false) {
              food.insert(0, order);
            } else if (isFood == false && inProgress == false) {
              beverages.insert(0, order);
            } else if (isPaid == false) {
              print("insert $order in complete Order");

              completeOrder.insert(0, order);
            }
          }

          return Stack(
            children: [
              ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height / 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bezahlen",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 55,
                            letterSpacing: 1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 25,
                            height: MediaQuery.of(context).size.width / 25,
                            color: Colors.green.withOpacity(0),
                            child: Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: MediaQuery.of(context).size.width / 50,
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
                        fontSize: MediaQuery.of(context).size.width / 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Zahlungsart:",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                60,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Bar",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                60,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Getrennt/Zusammen:",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                60,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Zusammen",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                60,
                                      ),
                                    ),
                                  ],
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
                                                      .width /
                                                  70,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                150,
                                      ),
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
                      color: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(15)),
                      ),
                      child: Text(
                        "Bezahl Anfrage Aufnehmen",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 70,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () {
                        acceptPayRequest(food: food, beverages: beverages);
                      }),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
