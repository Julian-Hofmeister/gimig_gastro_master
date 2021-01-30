import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AcceptPayRequestService {
  final _firestore = FirebaseFirestore.instance
      .collection('restaurants')
      .doc("${FirebaseAuth.instance.currentUser.email}")
      .collection('tables');

  Future acceptPayRequest({context, tableNumber}) async {
    Navigator.pop(context);

    //UPDATE STATUS
    await _firestore
        .doc("$tableNumber")
        .update({"status": "paid", "payRequest": false, "isPaid": true});

    // CHECK AS PAID
    QuerySnapshot querySnapshot =
        await _firestore.doc("$tableNumber").collection("orders").get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var item = querySnapshot.docs[i].id;
      print(item);
      await _firestore
          .doc("$tableNumber")
          .collection("orders")
          .doc("$item")
          .update({
        "isPaid": true,
      });
    }
    print("PAY REQUEST ACCEPTED");
  }
}
