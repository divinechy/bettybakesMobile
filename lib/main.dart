import 'package:bettymobile/src/components/RegForm.dart';
import 'package:bettymobile/src/components/locator.dart';
import 'package:bettymobile/src/components/myColors.dart';
import 'package:bettymobile/src/components/navService.dart';
import 'package:bettymobile/src/components/updateRecipient.dart';
import 'package:bettymobile/src/pages/login.dart';
import 'package:bettymobile/src/pages/master.dart';
import 'package:flutter/material.dart';
import 'package:bettymobile/src/pages/landing.dart';

void main() {
  //initializing our locator and the argument of Update Recipient
  setupLocator();
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: MyColors.PrimaryColor,
        accentColor: Colors.amber[500],
      ),
      debugShowCheckedModeBanner: false,
      home: Landing(),
      routes: <String, WidgetBuilder>{
        'login': (BuildContext context) => Login(),
        'master': (BuildContext context) => Master(),
        'registerRecipient': (BuildContext context) => RegForm(),
        'updateRecipient': (BuildContext context) =>
            UpdateRecipient(ModalRoute.of(context).settings.arguments)
      },
      navigatorKey: locator<NavigationService>().navigatorKey,
    ),
  );
}
