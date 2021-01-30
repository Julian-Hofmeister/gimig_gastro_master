import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance
    .collection('restaurants')
    .doc("${FirebaseAuth.instance.currentUser.email}")
    .collection('tables');

class AcceptOrderService {
  Future<void> acceptOrder({food, beverages, context, tableNumber}) async {
    if (food.isEmpty && beverages.isEmpty) {
      print("nothing to check");
      print("$food $beverages");
    } else {
      // BACK TO HOMESCREEN
      Navigator.pop(context);

      //UPDATE STATUS
      await _firestore.doc("$tableNumber").update({
        "status": "normal",
        "ableToPay": true,
        "orderRequest": false,
      });

      // ACCEPT ORDER
      QuerySnapshot querySnapshot =
          await _firestore.doc("$tableNumber").collection("orders").get();

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var item = querySnapshot.docs[i].id;
        print(item);
        await _firestore
            .doc("$tableNumber")
            .collection("orders")
            .doc("$item")
            .update({"inProgress": true});
      }
      print("ORDER ACCEPTED");
    }
  }

  Future<void> acceptBeverages({beverages, context, tableNumber}) async {
    if (beverages.isEmpty) {
      print("nothing to check");
      print("$beverages");
    } else {
      // BACK TO HOMESCREEN
      Navigator.pop(context);

      //UPDATE STATUS
      await _firestore
          .doc("$tableNumber")
          .update({"status": "normal", "ableToPay": true});

      for (int i = 0; i < beverages.length; i++) {
        var item = beverages[i].id;
        print(item);
        await _firestore
            .doc("$tableNumber")
            .collection("orders")
            .doc("$item")
            .update({"inProgress": true});
      }
      print("ORDER ACCEPTED");
    }
  }
}
