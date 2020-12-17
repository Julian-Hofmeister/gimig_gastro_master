import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimig_gastro_master/functions/authentication_servie.dart';
import 'package:gimig_gastro_master/main/route_generator.dart';
import 'package:gimig_gastro_master/screens/home_screen.dart';
import 'package:gimig_gastro_master/screens/login_screen.dart';
import 'package:provider/provider.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
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
        initialRoute: AuthenticationWrapper.id,
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  static const String id = 'auth_screen';
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomeScreen();
    }
    return LoginScreen();
  }
}
