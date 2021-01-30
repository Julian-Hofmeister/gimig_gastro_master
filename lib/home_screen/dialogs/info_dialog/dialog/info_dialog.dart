import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/home_screen/dialogs/info_dialog/services/accept_service_request_service.dart';

class InfoDialog extends StatelessWidget {
  InfoDialog({this.status, this.tableNumber});

  final String status;
  final String tableNumber;

  final AcceptServiceRequestService acceptServiceRequestService =
      AcceptServiceRequestService();

  @override
  Widget build(BuildContext context) {
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
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "TISCH $tableNumber",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "benötigt eine Bedienung",
                    style: TextStyle(letterSpacing: 2),
                  ),
                  SizedBox(height: 70),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 70,
                child: Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: Colors.purple[400],
                        ),
                        child: Center(
                            child: Text(
                          "Als Gelesen Markieren",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      onTap: () {
                        acceptServiceRequestService.acceptService(
                            context: context, tableNumber: tableNumber);
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
  }
}
