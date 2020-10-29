import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/components/drawer/order_drawer.dart';
import 'package:gimig_gastro_master/screens/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case HomeScreen.id:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case OrderDrawer.id:
        return MaterialPageRoute(builder: (_) => OrderDrawer());

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
