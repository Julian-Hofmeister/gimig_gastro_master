import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimig_gastro_master/functions/authentication_servie.dart';
import 'package:gimig_gastro_master/screens/home_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "E-mail:",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF303030),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 350,
                            height: 80,
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(60.0),
                                  ),
                                  borderSide: new BorderSide(
                                      color: Colors.deepOrangeAccent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Color(0xFFFF6633)),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(60.0),
                                  ),
                                ),
                              ),
                              cursorColor: Color(0xFF303030),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Passwort:",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF303030),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 350,
                            height: 80,
                            child: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                password = value;
                              },
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(60.0),
                                  ),
                                  borderSide: new BorderSide(
                                      color: Colors.deepOrangeAccent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Color(0xFFFF6633)),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(60.0),
                                  ),
                                ),
                              ),
                              cursorColor: Color(0xFF303030),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  // Text(
                  //   "LOGIN",
                  //   style: TextStyle(
                  //     fontSize: 100,
                  //     fontWeight: FontWeight.w900,
                  //     color: Color(0xFF303030),
                  //     letterSpacing: 1,
                  //   ),
                  // ),
                  //     SizedBox(
                  //       width: 100,
                  //     ),
                  //     GestureDetector(
                  //       onDoubleTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => WelcomeScreen(),
                  //           ),
                  //         );
                  //       },
                  //       child: SizedBox(
                  //         height: 120,
                  //         width: 125,
                  //         child: Image.asset(
                  //           "images/logos/Gimig Logo.png",
                  //           fit: BoxFit.fill,
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    width: 350,
                    height: 70,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        color: Color(0xFFFF6633),
                        splashColor: Colors.white,
                        highlightColor: Colors.grey,
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        onPressed: () {
                          context.read<AuthenticationService>().signIn(
                                email: email.trim(),
                                password: password.trim(),
                              );
                        }),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    "images/logos/Gimig Logo.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
