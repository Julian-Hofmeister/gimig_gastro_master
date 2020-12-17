import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/components/dialogs/error_dialog.dart';

checkConnectionStatus() async {
  bool _connectionStatus = await DataConnectionChecker().hasConnection;
  print("CURRENT CONNECTION STATUS: $_connectionStatus");
}

listenToConnection(context) async {
  print(DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.connected:
        print('Data connection is available.');
        break;
      case DataConnectionStatus.disconnected:
        print('You are disconnected from the internet.');
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(),
        );
        break;
    }
  }));
}

// checkConnection() async {
//   // Simple check to see if we have internet
//   // print("CONNECTION?: ${await DataConnectionChecker().hasConnection}");
//   // returns a bool
//
//   // We can also get an enum instead of a bool
//   print(
//       "CURRENT CONNECTION STATUS: ${await DataConnectionChecker().connectionStatus}");
//   // prints either DataConnectionStatus.connected
//   // or DataConnectionStatus.disconnected
//
//   // This returns the last results from the last call
//   // to either hasConnection or connectionStatus
//   // print("Last results: ${DataConnectionChecker().lastTryResults}");
//
//   // actively listen for status updates
//   // var listener = DataConnectionChecker().onStatusChange.listen((status) {
//   //   switch (status) {
//   //     case DataConnectionStatus.connected:
//   //       print('Data connection is available.');
//   //       break;
//   //     case DataConnectionStatus.disconnected:
//   //       print('You are disconnected from the internet.');
//   //       break;
//   //   }
//   // });
//
//   // close listener after 30 seconds, so the program doesn't run forever
//   // await Future.delayed(Duration(seconds: 30));
//   // await listener.cancel();
// }
