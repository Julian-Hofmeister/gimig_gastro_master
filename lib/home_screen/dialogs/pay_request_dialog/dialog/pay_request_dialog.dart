import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/home_screen/dialogs/order_dialog/dialog/order_dialog.dart';
import 'package:gimig_gastro_master/home_screen/dialogs/pay_request_dialog/components/card_item/card_item.dart';
import 'package:gimig_gastro_master/home_screen/dialogs/pay_request_dialog/services/accept_pay_request_service.dart';

class PayRequestDialog extends StatelessWidget {
  PayRequestDialog(
      {this.status,
      this.tableNumber,
      this.isCache,
      this.isTogether,
      this.spentTime});

  final String status;
  final String tableNumber;
  final bool isCache;
  final bool isTogether;
  final Timestamp spentTime;

  final AcceptPayRequestService acceptPayRequestService =
      AcceptPayRequestService();

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
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "TISCH $tableNumber",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "möchte Bezahlen",
                            style: TextStyle(letterSpacing: 2),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 70),
                  CardItem(
                    title: "Verbrachte Zeit:",
                    content: "2:10h",
                  ),
                  SizedBox(height: 20),
                  CardItem(
                    title: "Zahlungsart:",
                    content: isCache == true ? "Bar" : "Mit Karte",
                  ),
                  SizedBox(height: 20),
                  CardItem(
                    title: "Zusammen/Getrennt:",
                    content: isTogether == true ? "Zusammen" : "Getrennt",
                  ),
                  SizedBox(height: 20),
                  CardItem(
                    title: "Summe:",
                    content: "110,90€",
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: (context),
                        builder: (_) => OrderDialog(
                          tableNumber: tableNumber.toString(),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Color(0xFFEE7853),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          "Bestellung Anzeigen",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
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
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: Colors.blue[400],
                        ),
                        child: Center(
                            child: Text(
                          "Zahlungsanfrage Annehmen",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      onTap: () {
                        acceptPayRequestService.acceptPayRequest(
                          context: context,
                          tableNumber: tableNumber,
                        );
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
