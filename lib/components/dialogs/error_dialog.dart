import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  ErrorDialog({this.isOffline});
  final bool isOffline;

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
        child: Stack(
          children: [
            Center(
              child: Text(
                "Es tut uns leid. Es scheint sie haben keine Internetverbindung.",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 55,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "schließen",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 55,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
