import 'package:flutter/material.dart';

// TODO CLEAN LOOKING LOADING INDICATOR

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
