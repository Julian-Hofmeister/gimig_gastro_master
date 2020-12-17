import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CalledServiceDialog extends StatelessWidget {
  CalledServiceDialog({this.tableNumber});
  final int tableNumber;

  final _firestore = FirebaseFirestore.instance
      .collection("restaurants")
      .doc("venezia")
      .collection("tables");

  Future<void> acceptService({context}) async {
    //CLOSE DIALOG
    Navigator.of(context).pop();
    //UPDATE STATUS
    await _firestore.doc("$tableNumber").update({"status": "normal"});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      content: Container(
        width: 500,
        height: 250,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Der Tisch $tableNumber benötigt eine Bedienung",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 55,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: FlatButton(
                    color: Color(0xFFFFC68C),
                    splashColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Text(
                      "Angenommen",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 55,
                      ),
                    ),
                    onPressed: () {
                      acceptService(context: context);
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: OutlineButton(
                    borderSide: BorderSide(color: Color(0xFFFFC68C), width: 2),
                    color: Color(0xFFFF6633),
                    splashColor: Colors.white,
                    highlightColor: Color(0xFFFFC68C),
                    highlightedBorderColor: Color(0xFFFFC68C),
                    child: Text(
                      "In Liste lassen",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 55,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
