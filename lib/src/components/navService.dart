import 'package:bettymobile/src/models/recipientModel.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

//passing arguments 
  Future<dynamic> navigateTo(String routeName, RecipientModel model) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: model);
  }

  bool goBack() {
    return navigatorKey.currentState.pop();
  }
}
