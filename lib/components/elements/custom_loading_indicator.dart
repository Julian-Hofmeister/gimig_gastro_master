import 'package:flutter/material.dart';

// TODO CLEAN LOOKING LOADING INDICATOR

// TODO ON LOADING ERROR MESSAGE OUTPUT

class CustomLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}
