import 'package:flutter/material.dart';

class InfoBubble extends StatelessWidget {
  const InfoBubble({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.purpleAccent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60),
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
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
