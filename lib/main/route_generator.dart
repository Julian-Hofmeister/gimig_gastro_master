import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/main.dart';
import 'package:gimig_gastro_master/screens/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case AuthenticationWrapper.id:
        return MaterialPageRoute(builder: (_) => AuthenticationWrapper());

      case HomeScreen.id:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("ERROR"),
          ),
        );
      },
    );
  }
}
