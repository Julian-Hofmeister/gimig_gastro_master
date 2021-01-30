import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/home_screen/components/loading_indicator/custom_loading_indicator.dart';

class MessageDialog extends StatefulWidget {
  MessageDialog({this.status, this.tableNumber});

  final String status;
  final String tableNumber;

  final _firestore = FirebaseFirestore.instance
      .collection('restaurants')
      .doc("${FirebaseAuth.instance.currentUser.email}")
      .collection('tables');

  Future<void> acceptOrder({food, beverages, context}) async {
    if (food.isEmpty && beverages.isEmpty) {
      print("nothing to check");
      print("$food $beverages");
    } else {
      // BACK TO HOMESCREEN
      Navigator.pop(context);

      //UPDATE STATUS
      await _firestore
          .doc("$tableNumber")
          .update({"status": "normal", "ableToPay": true});

      // ACCEPT ORDER
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .doc("$tableNumber")
          .collection("orders")
          .get();

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var item = querySnapshot.docs[i].id;
        print(item);
        await _firestore
            .doc("$tableNumber")
            .collection("orders")
            .doc("$item")
            .update({"inProgress": true});
      }
      print("ORDER ACCEPTED");
    }
  }

  @override
  _MessageDialogState createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  bool isSwitched = false;

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
        List<Widget> completeOrder = [];
        List<Widget> beverages = [];
        List<Widget> food = [];

        final snapshotItem = snapshot.data.docs;

        // CREATE ORDERITEM
        for (var item in snapshotItem) {
          final itemName = item.data()['name'];
          final itemPrice = item.data()['price'];
          final itemAmount = item.data()['amount'];
          final isFood = item.data()['isFood'];

          final inProgress = item.data()['inProgress'];
          final isPaid = item.data()['isPaid'];

          final order = ListItem(
            name: itemName,
            price: itemPrice,
            amount: itemAmount,
          );

          // SORT ORDER
          if (isFood == true && inProgress == false) {
            food.insert(0, order);
          } else if (isFood == false && inProgress == false) {
            beverages.insert(0, order);
          } else if (isFood == true && isPaid == false) {
            print("insert $order in complete Order");
            completeOrder.insert(0, order);
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
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                    print(isSwitched);
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
                                      children: beverages,
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
                                      children: food,
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20)),
                            color: Colors.red[400],
                          ),
                          child: Center(
                              child: Text(
                            "Getränke Annehmen",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20)),
                              color: Colors.green[400],
                            ),
                            child: Center(
                                child: Text(
                              "Gesamte Bestellung Annehmen",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                          onTap: () {
                            widget.acceptOrder(
                                food: food,
                                beverages: beverages,
                                context: context);
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

class ListItem extends StatelessWidget {
  ListItem({this.name, this.amount, this.price});

  final String name;
  final int amount;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        height: 40,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
    );
  }
}
