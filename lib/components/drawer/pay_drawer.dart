import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/components/elements/custom_loading_indicator.dart';
import 'package:gimig_gastro_master/components/elements/order_item.dart';

class PayDrawer extends StatelessWidget {
  PayDrawer({this.tableNumber});
  final int tableNumber;

  final _firestore = Firestore.instance
      .collection('restaurants')
      .document('venezia')
      .collection('tables');

  Future acceptPayRequest({context}) async {
    Navigator.pop(context);

    //UPDATE STATUS
    await _firestore.document("$tableNumber").updateData({"status": "paid"});

    // CHECK AS PAID
    QuerySnapshot querySnapshot = await _firestore
        .document("$tableNumber")
        .collection("orders")
        .getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var item = querySnapshot.documents[i].documentID;
      print(item);
      await _firestore
          .document("$tableNumber")
          .collection("orders")
          .document("$item")
          .updateData({"isPaid": true});
    }
    print("PAY REQUEST ACCEPTED");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //STREAM
      stream: _firestore
          .document("$tableNumber")
          .collection("orders")
          .orderBy("timestamp")
          .snapshots(),
      builder: (context, snapshot) {
        // ON ERROR
        if (!snapshot.hasData) {
          return CustomLoadingIndicator();
        }

        // ITEM LISTS
        List<Widget> completeOrder = [];
        List<Widget> beverages = [];
        List<Widget> food = [];

        final snapshotItem = snapshot.data.documents;

        // CREATE ORDERITEM
        for (var item in snapshotItem) {
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
                          "Bezahlen",
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
                      "Tisch $tableNumber",
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Zahlungsart:",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.015,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Bar",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.015,
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
                                            MediaQuery.of(context).size.width *
                                                0.015,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Zusammen",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.015,
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
                                                      .width *
                                                  0.015,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: FlatButton(
                      color: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(15)),
                      ),
                      child: Text(
                        "Bezahl Anfrage Aufnehmen",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.015,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () {
                        acceptPayRequest(context: context);
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
