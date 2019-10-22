import 'dart:io';
import 'dart:math';

import 'package:bettymobile/src/pages/control.dart';
import 'package:bettymobile/src/pages/recipients.dart';
import 'package:bettymobile/src/pages/transfers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

enum FilterOptions { Logout }

class Master extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Recipients", Icons.people),
    new DrawerItem("Transfers", Icons.compare_arrows),
    new DrawerItem("Control", Icons.settings),
  ];
  @override
  _MasterState createState() => _MasterState();
}

class _MasterState extends State<Master> {
  int _selectedDrawerIndex = 0;
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Home();
      case 1:
        return new Recipients();
      case 2:
        return new Transfers();
      case 3:
        return new Control();
      default:
        return new Text("Error! Something Went Wrong");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(InkWell(
        onTap: () => _onSelectItem(i),
        child: new ListTile(
          leading: new Icon(d.icon, color: Color(0xff112b43)),
          title: new Text(
            d.title,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
          selected: i == _selectedDrawerIndex,
        ),
      ));
    }
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xff112b43),
          title: Text(widget.drawerItems[_selectedDrawerIndex].title),
          actions: <Widget>[
            PopupMenuButton(
              padding: EdgeInsets.all(10.0),
              elevation: 0.0,
              onSelected: (FilterOptions selectedValue) async {
                if (selectedValue == FilterOptions.Logout) {
                  try {
                    await FirebaseAuth.instance.signOut();
                    exit(0);
                  } catch (e) {}
                } else {
                  //nothing happens
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Log Out'),
                    ),
                    value: FilterOptions.Logout),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  "Betty Bakes Admin",
                  style: TextStyle(fontSize: 18.0),
                ),
                accountEmail: Text(""),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("images/user.png"),
                    backgroundColor: Colors.grey,
                  ),
                ),
                decoration: BoxDecoration(color: Color(0xff112b43)),
              ),
              Column(children: drawerOptions),
            ],
          ),
        ),
        body: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
    );
  }
}
