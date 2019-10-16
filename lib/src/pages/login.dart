import 'package:bettymobile/src/api/restAPI.dart';
import 'package:bettymobile/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _emailTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  FocusNode passwordnode = new FocusNode();
  //final formKey = new GlobalKey<FormState>();
  // bool _validateEmail = false;
  // bool _validatePassword = false;
  // bool _validateForgot = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/cakecover.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          //now we add a container to the stack
          Container(
            //the more the opacity the lighter or darker the image
            color: Colors.black.withOpacity(0.8),
            height: double.infinity,
            width: double.infinity,
          ),

          Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: Container(
                  margin: EdgeInsets.only(top: 80),
                  //align our container to the center
                  alignment: Alignment.center,
                  child: Center(
                    child: Form(
                      //   key: formKey,
                        child: Column(
                      children: <Widget>[
                        //padding for email
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white.withOpacity(0.9),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                //to send focus to next input field when we done with email
                                onFieldSubmitted: (String value) {
                                  FocusScope.of(context)
                                      .requestFocus(passwordnode);
                                },
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "Email ",
                                  icon: Icon(Icons.email),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailTextController,

                                //we want to validate the email address
                                 validator: (value){
                                  if (value.isEmpty){
                                   Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                   RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value))
                                    return 'Please Enter a Valid Email Address';
                                    else
                                     return null;
                                 }
                               },
                              ),
                            ),
                          ),
                        ),

                        //padding for password
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white.withOpacity(0.9),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                //we retrieve the passwordfocus here
                                focusNode: passwordnode,
                                textInputAction: TextInputAction.done,
                                cursorColor: Colors.deepPurpleAccent,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Password ",
                                  icon: Icon(Icons.lock),
                                  border: InputBorder.none,
                                  // focusColor: Colors.deepPurpleAccent
                                ),
                                //keyboardType: TextInputType.
                                controller: _passwordTextController,
                                //we want to validate the password
                                 validator: (value){
                                 if (value.isEmpty)
                                     return 'Password is required';
                                   else return null;
                                 },
                              ),
                            ),
                          ),
                        ),

                        //padding for login button
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ButtonTheme(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              height: 40,
                              minWidth: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                color: Color(0xff112b43),
                                child: Text('Sign In',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0)),
                                // minWidth: MediaQuery.of(context).size.width,
                                onPressed: () async {
                                    showDialog(
                                       barrierDismissible: false,
                                               context: context,
                                                  builder: (BuildContext context) {
                                                   return Center(child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white), 
                                        ),);
                                  });
                                  try {
                                    if (_emailTextController.text.isNotEmpty &&
                                        _passwordTextController
                                            .text.isNotEmpty) {
                                FirebaseUser _user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text)).user;
                                      if (_user == null) {
                                       Navigator.pop(context);
                                        Flushbar(
                                          title: 'Something Went Wrong!',
                                          message:
                                              'Please Check Your Internet Connection!',
                                          icon: Icon(
                                            Icons.info_outline, size: 28,
                                            color: Colors.white,
                                          ),
                                          leftBarIndicatorColor: Colors.white,
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                      } else {
                                        //passid of the document we want to get
                                         var shot = await  Firestore.instance.collection('admin').document(_user.uid).get();
                                           var data = User.fromJson(shot.data);
                                           var usertoken = data.token;
                                           await RestAPI.saveToken(usertoken);
                                       Navigator.pushNamed(context, 'master');
                                        }
                                    }
                              } catch (e) {
                                Navigator.pop(context);
                                    Flushbar(
                                      title: 'Something went wrong!',
                                      message: e.message,
                                    // message: 'User does not exist',
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
                        ),
                      ],
                    )),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
