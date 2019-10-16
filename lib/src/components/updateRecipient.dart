import 'package:bettymobile/src/components/navService.dart';
import 'package:flutter/material.dart';
import 'package:bettymobile/src/models/bankModel.dart';
import 'package:bettymobile/src/models/recipientModel.dart';
import 'package:flushbar/flushbar.dart';
import 'package:bettymobile/src/api/restAPI.dart';

import 'locator.dart';

class UpdateRecipient extends StatefulWidget {
  final RecipientModel model;
  UpdateRecipient(this.model);
  @override
  _UpdateRecipientState createState() => _UpdateRecipientState(this.model);
}

class _UpdateRecipientState extends State<UpdateRecipient> {
  RecipientModel model;
  _UpdateRecipientState(this.model);
  static String name;
  TextEditingController _type = new TextEditingController(text: 'NUBAN');
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _accountNumber = new TextEditingController();
  //TextEditingController _bankCode = new TextEditingController();
  TextEditingController _currency = new TextEditingController(text: 'NGN');
  TextEditingController _description = new TextEditingController();
  List<String> bankNames = new List<String>();
  // String _selectedVal;
  // int _selectedIndex;
  List<BankModel> models = new List<BankModel>();
   final NavigationService _navigationService = locator<NavigationService>();
  // String _code;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    //there is no need of getting list of banks anymore
    super.initState();
    setState(() {
      _name.text = model.name;
      _description.text = model.description;
      _accountNumber.text =
          model.details.accountnumber + " / " + model.details.bankname;
      _email.text = model.email;
    });
  }

  void validateAndSave() async {
    try {
      final form = formKey.currentState;
      if (form.validate()) {
        //save and continue, here we update recipient
        form.save();
        RecipientModel _model = new RecipientModel(
          name: _name.text,
          email: _email.text,
        );
        var res = await RestAPI.updateRecipient(_model, model.id);
        if (res != null) {
          //first pop the spinner then pop the form
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      } else {
        //let the user know the form is not valid
        Navigator.of(context).pop();
        Flushbar(
          title: 'Form is not valid!',
          message: 'Please ensure you fill the form correctly',
          icon: Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.white,
          ),
          leftBarIndicatorColor: Colors.white,
          duration: Duration(seconds: 5),
        )..show(context);
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
                        'Update / Delete Recipient',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 25.0, top: 30.0),
                        child: InkWell(
                          child: Icon(
                            Icons.delete_forever,
                            size: 35.0,
                          ),
                          onTap: () {
                            //showing dialog
                            try {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    title: new Text("Delete ${model.name}?"),
                                    content: new Text(
                                        "Are you sure you want to delete ${model.name}? This change is irrevisble."),
                                    actions: <Widget>[
                                      // usually buttons at the bottom of the dialog
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          FlatButton(
                                            child: new Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Color(0xff112b43)),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: new Text(
                                              "Yes Delete",
                                              style: TextStyle(
                                                  color: Color(0xff112b43)),
                                            ),
                                            onPressed: () async {
                                              //remove dialog and show spinner while attempting to delete recipient
                                              Navigator.of(context).pop();
                                              var res =
                                                  await RestAPI.deleteRecipient(
                                                      model.id);
                                              if (res != null) {
                                                 _navigationService.goBack();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
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
                          },
                        )),
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
                              controller: _type,
                              readOnly: true,
                              decoration: InputDecoration(labelText: 'Type'),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: _name,
                              decoration: InputDecoration(labelText: 'Name'),
                              validator: (value) =>
                                  value.isEmpty ? 'Name cannot be blank' : null,
                              maxLength: 35,
                              onSaved: (value) => _name.text = value,
                            ),
                          ),

                          //email is not compulsory
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: _email,
                              decoration: InputDecoration(labelText: 'Email'),
                              // validator: (value) =>
                              //     value.isEmpty ? 'Name cannot be blank' : null,
                              // maxLength: 35,
                              onSaved: (value) => _email.text = value,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: _accountNumber,
                              readOnly: true,
                              decoration:
                                  InputDecoration(labelText: 'Account Number'),
                              keyboardType: TextInputType.number,
                              validator: (value) => value.length < 10
                                  ? 'Account Number cannot be less than 10 digits'
                                  : null,
                              onSaved: (value) => _accountNumber.text = value,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              controller: _description,
                              readOnly: true,
                              decoration:
                                  InputDecoration(labelText: 'Description'),
                              validator: (value) => value.isEmpty
                                  ? 'Description cannot be blank'
                                  : null,
                              maxLength: 40,
                              onSaved: (value) => _description.text = value,
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
                                      child: Text("Update",
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
                                          validateAndSave();
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
