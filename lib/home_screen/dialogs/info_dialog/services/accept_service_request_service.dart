import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AcceptServiceRequestService {
  final _firestore = FirebaseFirestore.instance
      .collection('restaurants')
      .doc("${FirebaseAuth.instance.currentUser.email}")
      .collection('tables');

  Future<void> acceptService({context, tableNumber}) async {
    //CLOSE DIALOG
    Navigator.of(context).pop();
    //UPDATE STATUS
    await _firestore
        .doc("$tableNumber")
        .update({"status": "normal", "serviceRequest": false});
  }
}
