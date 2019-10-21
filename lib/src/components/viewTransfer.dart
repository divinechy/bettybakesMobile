import 'package:bettymobile/src/api/restAPI.dart';
import 'package:bettymobile/src/models/transferModel.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'locator.dart';
import 'navService.dart';

class ViewTransfer extends StatefulWidget {
  final int id;
  ViewTransfer(this.id);
  @override
  _ViewTransferState createState() => _ViewTransferState(this.id);
}

class _ViewTransferState extends State<ViewTransfer> {
  int id;
  _ViewTransferState(this.id);

  final NavigationService _navigationService = locator<NavigationService>();

  final formKey = new GlobalKey<FormState>();
  String code;
  
  TextEditingController _source = new TextEditingController(text: 'balance');
  TextEditingController _amount = new TextEditingController();
  TextEditingController _reason = new TextEditingController();
  TextEditingController _recipient = new TextEditingController();
  TextEditingController _currency = new TextEditingController(text: 'NGN');
  TextEditingController _reference = new TextEditingController();
  TextEditingController _otp = new TextEditingController();


   void finalizeTransfer() async {
    try {
       final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        TransferModel trans = new TransferModel(
          transfercode: code,
          otp: _otp.text
        );
        var doTransfer = await RestAPI.finalizeTransfer(trans);
      }
    } catch (e) {
      Navigator.of(context).pop();
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
  }


  @override
  void initState() {
    super.initState();
    //we try to process the transfer by getting otp
    RestAPI.getTransferById(id).then((result) {
      setState(() {
        _amount.text = result.amount.toString();
        _reason.text = result.reason;
        _recipient.text = result.recipient.name;
        _reference.text = result.reference;
        code = result.transfercode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 15.0),
                      child: Text(
                        'View Transfer',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: _source,
                              readOnly: true,
                              decoration: InputDecoration(labelText: 'Source'),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: _amount,
                              decoration: InputDecoration(labelText: 'Amount'),
                              maxLength: 35,
                              readOnly: true,
                            ),
                          ),

                          //email is not compulsory
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: _reason,
                              decoration: InputDecoration(labelText: 'Reason'),
                              readOnly: true,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: _recipient,
                              readOnly: true,
                              decoration:
                                  InputDecoration(labelText: 'Recipient'),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: _otp,
                              decoration:
                                  InputDecoration(labelText: 'OTP'),
                                  autofocus: false,
                              validator: (value) =>
                                  value.isEmpty ? 'Please enter the OTP sent to your phone' : null,
                              maxLength: 10,
                              onSaved: (value) => _otp.text = value
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: _currency,
                              readOnly: true,
                              decoration:
                                  InputDecoration(labelText: 'Currency'),
                            ),
                          ),
                          //row for buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.0,
                                      top: 15.0,
                                      right: 5.0,
                                      bottom: 5.0),
                                  child: ButtonTheme(
                                    // splashColor: Colors.red,
                                    height: 30,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Color(0xff112b43),
                                      child: Text("Cancel",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                      onPressed: () async {
                                        _navigationService.goBack();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.0,
                                      top: 15.0,
                                      right: 15.0,
                                      bottom: 5.0),
                                  child: ButtonTheme(
                                    height: 30,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Color(0xff112b43),
                                      child: Text("Finalize transfer",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                      onPressed: () async {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              );
                                            });
                                        try {
                                          finalizeTransfer();
                                        } catch (e) {
                                          Navigator.pop(context);
                                          Flushbar(
                                            title: 'Something went wrong!',
                                            message: e.message,
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
