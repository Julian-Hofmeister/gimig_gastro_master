import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderBubble extends StatefulWidget {
  OrderBubble({this.timestamp});

  final Timestamp timestamp;

  @override
  _OrderBubbleState createState() => _OrderBubbleState();
}

class _OrderBubbleState extends State<OrderBubble> {
  double checkPassedTime() {
    return (DateTime.now().millisecondsSinceEpoch.toDouble() -
            widget.timestamp.millisecondsSinceEpoch) *
        0.001;
  }

  double animatedSize = 60;
  double animatedCorner = 60;

  int delay = 30;
  //
  // timer() {
  //   Future.delayed(Duration(seconds: delay), () {
  //     setState(() {
  //       animatedSize = 300;
  //       animatedCorner = 300;
  //     });
  //   });
  //   Future.delayed(Duration(seconds: delay * 2), () {
  //     setState(() {
  //       animatedCorner = 10;
  //     });
  //   });
  // }

  @override
  initState() {
    super.initState();
    // timer();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: AnimatedContainer(
        width: animatedSize,
        height: animatedSize,
        duration: Duration(seconds: delay),
        decoration: BoxDecoration(
          color: Colors.deepOrange[300],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(animatedCorner),
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.menu_book,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
