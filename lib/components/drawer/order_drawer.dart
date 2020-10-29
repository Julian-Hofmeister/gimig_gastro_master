import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/components/elements/order_item.dart';

// ignore: must_be_immutable
class OrderDrawer extends StatelessWidget {
  static const String id = "order_drawer";
  OrderDrawer({this.tableNumber});

  final _firestore = Firestore.instance;

  String tableNumber;
  List completeOrder = [];

  // Future<void> checkOrder() async {
  //   for (Widget item in completeOrder) {
  //     _firestore
  //         .collection("restaurants")
  //         .document("venezia")
  //         .collection("tables")
  //         .document("$tableNumber")
  //         .collection("orders").document("${item}")
  //         .updateData({
  //       "inProgress": true,
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    final _firestore = Firestore.instance;

    return Dialog(
      insetPadding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.6,
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height / 50),
          width: MediaQuery.of(context).size.width * 0.4,
          color: Colors.white,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tisch $tableNumber",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 45,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: MediaQuery.of(context).size.width / 50,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 25,
              ),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection("restaurants")
                          .document("venezia")
                          .collection("tables")
                          .document("$tableNumber")
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
                        for (var item in item) {
                          final itemName = item.data['name'];
                          final itemPrice = item.data['price'];
                          final isFood = item.data['isFood'];
                          final inProgress = item.data['inProgress'];

                          final order = OrderItem(
                            itemName: itemName,
                            itemPrice: itemPrice,
                          );

                          if (isFood == true) {
                            food.insert(0, order);
                          } else {
                            beverages.insert(0, order);
                          }
                        }
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Speisen:",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 150,
                            ),
                            Column(
                              children: food,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 40,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Getränke:",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 150,
                            ),
                            Column(
                              children: beverages,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 20,
                            ),
                            Align(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.height / 16,
                                child: FlatButton(
                                  color: Colors.deepOrangeAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  child: Text(
                                    "Bestellung Angenommen",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              70,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  onPressed: () async {
                                    // checkOrder();
                                    print("order accepted");
                                    // var docs = _firestore
                                    //     .collection('restaurants')
                                    //     .document('venezia')
                                    //     .collection('tables')
                                    //     .document('$tableNumber')
                                    //     .collection('orders')
                                    //     .document();

                                    final QuerySnapshot result = await Firestore
                                        .instance
                                        .collection('restaurants')
                                        .document('venezia')
                                        .collection('tables')
                                        .document("$tableNumber")
                                        .collection('orders')
                                        .getDocuments();
                                    final List<DocumentSnapshot> documents =
                                        result.documents;

                                    documents.forEach((data) {
                                      _firestore
                                          .collection('restaurants')
                                          .document('venezia')
                                          .collection('tables')
                                          .document("$tableNumber")
                                          .collection('orders')
                                          .document("$data")
                                          .updateData({"inProgress": true});
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
