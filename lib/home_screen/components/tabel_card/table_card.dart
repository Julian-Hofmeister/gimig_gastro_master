import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/bubbles/info_bubble.dart';
import 'components/bubbles/order_bubble.dart';
import 'components/bubbles/pay_request_bubble.dart';

class TableCard extends StatelessWidget {
  TableCard(
      {this.tableNumber,
      this.status,
      this.timestamp,
      this.payRequest,
      this.serviceRequest,
      this.orderRequest});

  final String tableNumber;
  final String status;
  final Timestamp timestamp;
  final bool payRequest;
  final bool serviceRequest;
  final bool orderRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 130,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          orderRequest == true
              ? OrderBubble(timestamp: timestamp)
              : Container(),
          payRequest == true ? PayRequestBubble() : Container(),
          serviceRequest == true ? InfoBubble() : Container(),
          Center(
              child: Text(
            "$tableNumber",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w500,
            ),
          )),
        ],
      ),
    );
  }
}
