import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/home_screen/components/loading_indicator/custom_loading_indicator.dart';
import 'package:gimig_gastro_master/home_screen/components/background/image_background.dart';
import 'package:gimig_gastro_master/home_screen/components/tabel_card/table_card.dart';
import 'package:gimig_gastro_master/connection/services/connection_check.dart';
import 'package:gimig_gastro_master/home_screen/dialogs/error_dialog.dart';
import 'package:gimig_gastro_master/home_screen/dialogs/info_dialog/dialog/info_dialog.dart';
import 'package:gimig_gastro_master/home_screen/dialogs/order_dialog/dialog/order_dialog.dart';
import 'package:gimig_gastro_master/home_screen/dialogs/pay_request_dialog/dialog/pay_request_dialog.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int drawerTableNumber;
  String drawerStatus;
  bool isOffline = false;
  String currentUserEmail = FirebaseAuth.instance.currentUser.email;

  var _firestore = FirebaseFirestore.instance
      .collection("restaurants")
      .doc("${FirebaseAuth.instance.currentUser.email}")
      .collection("tables");

  // ON CONNECTION CHANGE
  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      if (isOffline == true) {
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(
            isOffline: isOffline,
          ),
        );
      }
    });
  }

  @override
  initState() {
    super.initState();

    listenToConnection(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xFFFFC68C),
      body: Stack(
        children: [
          ImageBackground(
            backgroundImage: "images/BackgroundImage.jpg",
          ),
          StreamBuilder<QuerySnapshot>(
            // STREAM
            stream: _firestore.orderBy("tableNumber").snapshots(),
            builder: (context, snapshot) {
              // ON ERROR
              if (!snapshot.hasData) {
                return CustomLoadingIndicator();
              }

              // ITEM LISTS
              List<Widget> normalTables = [];
              List<Widget> orderedTables = [];

              final table = snapshot.data.docs;

              // CREATE TABLECARD WITH GESTUREDETECTOR
              for (var table in table) {
                final tableNumber = table.data()["tableNumber"];
                final status = table.data()["status"];
                final Timestamp timestamp = table.data()["orderTime"];
                final payRequest = table.data()["payRequest"];
                final orderRequest = table.data()["orderRequest"];

                final isCache = table.data()["isCache"];
                final isTogether = table.data()["isTogether"];
                final spentTime = table.data()["spentTime"];

                final serviceRequest = table.data()["serviceRequest"];

                if (timestamp != null) {
                  print(timestamp.millisecondsSinceEpoch);
                  print(DateTime.now().millisecondsSinceEpoch.toInt());
                  print(DateTime.now().millisecondsSinceEpoch.toInt() -
                      timestamp.millisecondsSinceEpoch);
                }

                final tableCard = GestureDetector(
                  child: TableCard(
                    tableNumber: tableNumber.toString(),
                    status: status,
                    timestamp: timestamp,
                    payRequest: payRequest,
                    orderRequest: orderRequest,
                    serviceRequest: serviceRequest,
                  ),
                  onTap: () {
                    if (orderRequest == true) {
                      showDialog(
                        context: (context),
                        builder: (_) => OrderDialog(
                          tableNumber: tableNumber.toString(),
                        ),
                      );
                    }
                    if (payRequest == true) {
                      showDialog(
                        context: (context),
                        builder: (_) => PayRequestDialog(
                          tableNumber: tableNumber.toString(),
                          isCache: isCache,
                          isTogether: isTogether,
                          spentTime: spentTime,
                        ),
                      );
                    }
                    if (serviceRequest == true) {
                      showDialog(
                        context: (context),
                        builder: (_) => InfoDialog(
                          tableNumber: tableNumber.toString(),
                        ),
                      );
                    }
                    if (status == "normal") {
                      showDialog(
                        context: (context),
                        builder: (_) => OrderDialog(
                          tableNumber: tableNumber.toString(),
                        ),
                      );
                    }
                  },
                );

                // SORT TABLES
                if (table.data()["payRequest"] == true ||
                    table.data()["orderRequest"] == true ||
                    table.data()["serviceRequest"] == true) {
                  orderedTables.insert(0, tableCard);
                } else {
                  normalTables.insert(normalTables.length, tableCard);
                }
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //ORDERED TABLE LIST | ON FULL
                  if (orderedTables.isNotEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.263,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F8F8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 3,
                            blurRadius: 25,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: GridView.count(
                        childAspectRatio: (200 / 130),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.02),
                        crossAxisCount: 1,
                        children: orderedTables,
                      ),
                    ),

                  //ORDERED TABLE LIST | ON EMPTY
                  if (orderedTables.isEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.263,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F8F8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 3,
                            blurRadius: 25,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Keine neuen Bestellungen ",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),

                  //NORMAL TABLE LIST
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.count(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.02),
                          childAspectRatio: (200 / 130),
                          crossAxisCount: 3,
                          children: normalTables),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
