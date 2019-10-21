import 'package:bettymobile/src/models/recipientModel.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

//passing arguments 
  Future<dynamic> navigateToRecipient(String routeName, RecipientModel model) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: model);
  }

  Future<dynamic> navigateToTransfer(String routeName, int id) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: id);
  }

  bool goBack() {
    return navigatorKey.currentState.pop();
  }
}
