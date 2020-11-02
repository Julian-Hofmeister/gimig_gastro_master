import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/components/drawer/action_drawer.dart';
import 'package:gimig_gastro_master/components/drawer/order_drawer.dart';
import 'package:gimig_gastro_master/components/drawer/pay_drawer.dart';
import 'package:gimig_gastro_master/components/elements/table_card.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestore = Firestore.instance;

  int drawerTableNumber;
  String drawerStatus;

  Widget checkDrawer() {
    if (drawerStatus == "orderRequest" || drawerStatus == "ordered") {
      return OrderDrawer(tableNumber: drawerTableNumber);
    }
    if (drawerStatus == "payRequest") {
      return PayDrawer(tableNumber: drawerTableNumber);
    }
    if (drawerStatus == "normal" || drawerStatus == "clear") {
      return ActionDrawer(tableNumber: drawerTableNumber);
    } else {
      return OrderDrawer(tableNumber: drawerTableNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: checkDrawer(),
      drawerEdgeDragWidth: 200,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xFFFFC68C),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("restaurants")
            .document("venezia")
            .collection("tables")
            .orderBy("tableNumber")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
              ),
            );
          }
          final table = snapshot.data.documents;
          List<Widget> tables = [];
          List<Widget> orderedTables = [];
          for (var table in table) {
            final tableNumber = table.data["tableNumber"];
            final status = table.data["status"];
            print(tableNumber);

            final tableCard = GestureDetector(
              onTap: () {
                setState(() {
                  drawerTableNumber = tableNumber;
                  drawerStatus = status;
                  print("$drawerTableNumber");
                  print("CLICK!!");
                  Scaffold.of(context).openEndDrawer();
                });
              },
              child: TableCard(
                tableNumber: tableNumber.toString(),
                status: status,
              ),
            );

            if (table.data["status"] == "ordered" ||
                table.data["status"] == "payRequest" ||
                table.data["status"] == "orderRequest") {
              orderedTables.insert(0, tableCard);
            } else {
              tables.insert(tables.length, tableCard);
            }
          }
          return Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/BackgroundImage.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (orderedTables.isNotEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
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
                            MediaQuery.of(context).size.height / 50),
                        childAspectRatio:
                            ((MediaQuery.of(context).size.width / 5.4) /
                                (MediaQuery.of(context).size.height / 5)),
                        crossAxisCount: 1,
                        children: orderedTables,
                      ),
                    ),
                  if (orderedTables.isEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
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
                            fontSize: MediaQuery.of(context).size.width / 60,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.count(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height / 50),
                          childAspectRatio:
                              ((MediaQuery.of(context).size.width / 5.4) /
                                  (MediaQuery.of(context).size.height / 5)),
                          crossAxisCount: 3,
                          children: tables),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 18,
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
              ),
            ],
          );
        },
      ),
    );
  }
}
