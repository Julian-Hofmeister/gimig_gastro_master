import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimig_gastro_master/functions/connection_check.dart';
import 'package:gimig_gastro_master/main/route_generator.dart';
import 'package:gimig_gastro_master/screens/home_screen.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);

  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Roboto",
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: HomeScreen.id,
    );
  }
}
