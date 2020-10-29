import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/components/elements/table_card.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawerEdgeDragWidth: 0,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xFFFFC68C),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
              padding: EdgeInsets.all(MediaQuery.of(context).size.height / 50),
              childAspectRatio: ((MediaQuery.of(context).size.width / 5) /
                  (MediaQuery.of(context).size.height / 5)),
              crossAxisCount: 1,
              children: [
                TableCard(),
                TableCard(),
                TableCard(),
                TableCard(),
                TableCard(),
                TableCard(),
                TableCard(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<QuerySnapshot>(
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
                  for (var table in table) {
                    final tableNumber = table.data["tableNumber"];
                    print(tableNumber);

                    final tableCard = TableCard(
                      tableNumber: tableNumber.toString(),
                    );

                    if (false) {
                    } else {
                      tables.insert(tables.length, tableCard);
                    }
                  }
                  return GridView.count(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height / 50),
                      childAspectRatio:
                          ((MediaQuery.of(context).size.width / 5) /
                              (MediaQuery.of(context).size.height / 5)),
                      crossAxisCount: 3,
                      children: tables);
                },
              ),
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
    );
  }
}
