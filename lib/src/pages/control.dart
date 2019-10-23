import 'package:bettymobile/src/api/restAPI.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Control extends StatefulWidget {
  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.white,
          height: double.infinity,
          child: ListView(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: Image.asset(
                            'images/balance.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ButtonTheme(
                            height: 40,
                            minWidth: 300,
                            child: RaisedButton(
                               child: Text('Check Balance', style: TextStyle(fontSize: 20.0),),
                              onPressed: () async {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      );
                                    });
                                try {
                                  var res = await RestAPI.checkBalance();
                                  Navigator.pop(context);
                                  Flushbar(
                                    title: 'Your account balance is',
                                    message: '${res[0].currency}${res[0].balance}',
                                    icon: Icon(
                                      Icons.info_outline,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                    leftBarIndicatorColor: Colors.white,
                                    duration: Duration(seconds: 5),
                                  )..show(context);
                                } catch (e) {
                                  Navigator.pop(context);
                                  Flushbar(
                                    title: 'Something went wrong!',
                                    message: e,
                                    icon: Icon(
                                      Icons.info_outline,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                    leftBarIndicatorColor: Colors.white,
                                    duration: Duration(seconds: 5),
                                  )..show(context);
                                }
                              },
                              textColor: Colors.white,
                              elevation: 5,
                              color: Color(0xff112b43)
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
