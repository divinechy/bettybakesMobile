import 'package:bettymobile/src/api/restAPI.dart';
import 'package:bettymobile/src/models/recipientModel.dart';
import 'package:bettymobile/src/models/transferModel.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class InitTransfer extends StatefulWidget {
  @override
  _InitTransferState createState() => _InitTransferState();
}

class _InitTransferState extends State<InitTransfer> {
   TextEditingController _source = new TextEditingController(text: 'balance');
   int _amount;
  String _reason;
  String _recipientCode;
  TextEditingController _currency = new TextEditingController(text: 'NGN');
  String _reference;
  List<String> recipientNames = new List<String>();
  String _selectedVal;
  int _selectedIndex;
  List<RecipientModel> models = new List<RecipientModel>();
  String _code;

  @override
  void initState() {
    super.initState();
    RestAPI.getListRecipients().then((result) {
      for (var item in result) {
        setState(() {
          models = result;
          recipientNames.add(item.name);
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
        TransferModel _model = new TransferModel(
              source: _source.text,
              amount: _amount,
              currency: _currency.text,
              reason: _reason,
              recipient: _recipientCode,
              reference: _reference
            );
        var res = await RestAPI.initiateTransfer(_model);
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
                'Initiate Transfer',
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
                               style: TextStyle(color: Colors.black ),
                              controller: _source,
                              readOnly: true,
                              decoration: InputDecoration(labelText: 'Source'),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                               style: TextStyle(color: Colors.black ),
                              decoration: InputDecoration(labelText: 'Amount'),
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              validator: (value) =>
                                  value.isEmpty ? 'Amount cannot be blank' : null,
                              maxLength: 30,
                              onSaved: (value) => _amount = int.parse(value) 
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                               style: TextStyle(color: Colors.black ),
                              decoration:
                                  InputDecoration(labelText: 'Reason'),
                              autofocus: false,
                              validator: (value) => value.isEmpty
                                  ? 'Reason cannot be blank'
                                  : null,
                              maxLength: 35,
                              onSaved: (value) => _reason = value,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                               style: TextStyle(color: Colors.black ),
                              decoration:
                                  InputDecoration(labelText: 'Reference'),
                                  autofocus: false,
                              validator: (value) => value.isEmpty
                                  ? 'Reference cannot be blank'
                                  : null,
                              maxLength: 30,
                              onSaved: (value) => _reference = value,
                            ),
                          ),

                          //picker for bank code
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: DropdownButtonFormField<String>(
                               style: TextStyle(color: Colors.black ),
                              onSaved: (value) => _recipientCode = _code,
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              //for dropdownbuttonformfield we use null not isempty
                              validator: (String value) {
                                if (value == null) {
                                  return 'Please select a recipient to be paid from the list';
                                } else
                                  return null;
                              },
                              disabledHint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('No recipient to select yet')),
                              value: _selectedVal,
                              items: recipientNames
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
                                      recipientNames.indexOf(_selectedVal);
                                  _code = models[_selectedIndex].recipientCode;
                                });
                              },
                              isExpanded: false,
                              hint: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Select the recipient to be paid'),
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
                               style: TextStyle(color: Colors.black ),
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
                                       validateAndSave();
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