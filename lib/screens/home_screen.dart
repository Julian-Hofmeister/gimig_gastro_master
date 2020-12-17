import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/components/dialogs/called_service_dialog.dart';
import 'package:gimig_gastro_master/components/dialogs/error_dialog.dart';
import 'package:gimig_gastro_master/components/drawer/action_drawer.dart';
import 'package:gimig_gastro_master/components/drawer/order_drawer.dart';
import 'package:gimig_gastro_master/components/drawer/pay_drawer.dart';
import 'package:gimig_gastro_master/components/elements/custom_loading_indicator.dart';
import 'package:gimig_gastro_master/components/elements/image_background.dart';
import 'package:gimig_gastro_master/components/elements/table_card.dart';
import 'package:gimig_gastro_master/functions/connection_check.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO BUILD LOGIN

  int drawerTableNumber;
  String drawerStatus;
  bool isOffline = false;
  String currentUserEmail = FirebaseAuth.instance.currentUser.email;

  var _firestore = FirebaseFirestore.instance
      .collection("restaurants")
      .doc("${FirebaseAuth.instance.currentUser.email}")
      .collection("tables");

  //CHECK DRAWER
  Widget checkDrawer() {
    if (drawerStatus == "orderRequest" || drawerStatus == "ordered") {
      return OrderDrawer(tableNumber: drawerTableNumber);
    }
    if (drawerStatus == "payRequest") {
      return PayDrawer(tableNumber: drawerTableNumber);
    }
    if (drawerStatus == "normal" || drawerStatus == "clear") {
      return ActionDrawer(tableNumber: drawerTableNumber);
    }
    if (drawerStatus == "calledService") {
      return CalledServiceDialog(tableNumber: drawerTableNumber);
    } else {
      return ActionDrawer(tableNumber: drawerTableNumber);
    }
  }

  //OPEN DRAWER
  void openDrawer({tableNumber, status, context}) {
    setState(() {
      drawerTableNumber = tableNumber;
      drawerStatus = status;

      Scaffold.of(context).openEndDrawer();
    });
  }

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
      endDrawer: checkDrawer(),
      drawerEdgeDragWidth: 200,
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

                final tableCard = GestureDetector(
                  child: TableCard(
                    tableNumber: tableNumber.toString(),
                    status: status,
                  ),
                  onTap: () {
                    openDrawer(
                      tableNumber: tableNumber,
                      status: status,
                      context: context,
                    );
                  },
                );

                // SORT TABLES
                if (table.data()["status"] == "ordered" ||
                    table.data()["status"] == "payRequest" ||
                    table.data()["status"] == "calledService" ||
                    table.data()["status"] == "orderRequest") {
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
                      width: MediaQuery.of(context).size.width * 0.25,
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
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.02),
                        childAspectRatio:
                            ((MediaQuery.of(context).size.width * 0.185) /
                                (MediaQuery.of(context).size.height * 0.2)),
                        crossAxisCount: 1,
                        children: orderedTables,
                      ),
                    ),

                  //ORDERED TABLE LIST | ON EMPTY
                  if (orderedTables.isEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
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
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Keine neuen Bestellungen ",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.015,
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
                          childAspectRatio:
                              ((MediaQuery.of(context).size.width * 0.185) /
                                  (MediaQuery.of(context).size.height * 0.2)),
                          crossAxisCount: 3,
                          children: normalTables),
                    ),
                  ),

                  // SIDE NAVIGATION BAR
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.05,
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
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
