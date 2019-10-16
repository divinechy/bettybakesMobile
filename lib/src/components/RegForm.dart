import 'package:bettymobile/src/models/bankModel.dart';
import 'package:bettymobile/src/models/recipientModel.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:bettymobile/src/api/restAPI.dart';

class RegForm extends StatefulWidget {
  @override
  _RegFormState createState() => _RegFormState();
}

class _RegFormState extends State<RegForm> {
  //here we are not using controllers only for those we are passing default values to
  //rather we will use OnSave on the form so when formState is saved..
  TextEditingController _type = new TextEditingController(text: 'NUBAN');
  String _name;
  String _accountNumber;
  String _bankCode;
  TextEditingController _currency = new TextEditingController(text: 'NGN');
  String _description;
  List<String> bankNames = new List<String>();
  String _selectedVal;
  int _selectedIndex;
  List<BankModel> models = new List<BankModel>();
  String _code;

  @override
  void initState() {
    super.initState();
    RestAPI.getListBanks().then((result) {
      for (var item in result.bankModels) {
        setState(() {
          models = result.bankModels;
          bankNames.add(item.name);
        });
      }
    });
  }

  void validateAndSave() async {
    try {
      final form = formKey.currentState;
      if (form.validate()) {
        //save and continue
        form.save();
        RecipientModel _model = new RecipientModel(
            type: _type.text,
            name: _name,
            accountnumber: _accountNumber,
            bankcode: _bankCode,
            currency: _currency.text,
            description: _description);
        var res = await RestAPI.createRecipient(_model);
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

  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
        child: Scaffold(
          body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 15.0),
              child: Text(
                'Create Recipient',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
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
                              decoration: InputDecoration(labelText: 'Name'),
                              autofocus: false,
                              validator: (value) =>
                                  value.isEmpty ? 'Name cannot be blank' : null,
                              maxLength: 35,
                              onSaved: (value) => _name = value,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Account Number'),
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              validator: (value) => value.length < 10
                                  ? 'Account Number cannot be less than 10 digits'
                                  : null,
                              maxLength: 12,
                              onSaved: (value) => _accountNumber = value,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Description'),
                                  autofocus: false,
                              validator: (value) => value.isEmpty
                                  ? 'Description cannot be blank'
                                  : null,
                              maxLength: 40,
                              onSaved: (value) => _description = value,
                            ),
                          ),

                          //picker for bank code
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: DropdownButtonFormField<String>(
                              onSaved: (value) => _bankCode = _code,
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              //for dropdownbuttonformfield we use null not isempty
                              validator: (String value) {
                                if (value == null) {
                                  return 'Please select a bank from the list';
                                } else
                                  return null;
                              },
                              disabledHint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('No bank to select yet')),
                              value: _selectedVal,
                              items: bankNames
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, top: 10.0),
                                              child: Text(value),
                                            ))
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String value) async {
                                setState(() {
                                  _selectedVal = value;
                                  _selectedIndex =
                                      bankNames.indexOf(_selectedVal);
                                  //this code is what we are really interested in not the name
                                  _code = models[_selectedIndex].code;
                                });
                              },
                              isExpanded: false,
                              hint: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Select the bank'),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                color: Color(0xff112b43),
                                size: 30.0,
                              ),
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
                                        Navigator.of(context).pop();
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
                                      child: Text("Submit",
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
      );
  }
}
