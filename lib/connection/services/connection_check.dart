import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_master/home_screen/dialogs/error_dialog.dart';

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
