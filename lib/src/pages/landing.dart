import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'login.dart';
import 'package:flutter/services.dart';


class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget imagecarousel = new Container(
      height: MediaQuery.of(context).size.height / 2 ,
      color: Colors.white,
      child: Carousel(
        images: [
           Image.asset("images/hotbread.jpg", fit: BoxFit.cover,),
           Image.asset("images/cake.jpg", fit: BoxFit.cover),
           Image.asset("images/chocolatecake.jpg", fit: BoxFit.cover),
           Image.asset("images/waffles.jpg", fit: BoxFit.cover),
        ],
         animationCurve: Curves.bounceOut,
         animationDuration: Duration(milliseconds: 1000),
         indicatorBgPadding: 0.4,
          dotSize: 7.0,
          dotIncreasedColor: Colors.white
      ),
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color(0xff112b43),
        statusBarIconBrightness: Brightness.light, 
    ));
     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return WillPopScope(
             onWillPop: () {
        return Future.value(false);
        },
      child: Scaffold(
        backgroundColor: Colors.white,
           body: SafeArea(
             
              child: Stack(
              children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget> [
                                    imagecarousel,
                   Expanded(
                       flex: 1,
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 0.0),
                          child: Text("Betty Bakes Mobile", style: 
                            TextStyle(color: Colors.blueAccent, fontSize: 20.0, fontWeight: FontWeight.bold) 
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.0, top: 5.0, left: 10.0, right: 10.0),
                             child: Text("Welcome", textAlign: TextAlign.center, style: 
                        TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal,),)
                        )
                      ],
                      )
                     ),
            Expanded(
                     flex: 1,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         ButtonTheme(
                          // splashColor: Colors.red,
                           height: 40,
                           minWidth: 200,
                           child: RaisedButton(
                              color: Color(0xff112b43),
                              child: Text("Continue to  Login", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                              onPressed: (){
                              Navigator.pushNamed(context, 'login');
                           },
                           shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),), 
                           ),
                         )
                       ],
                     )
                   )
                    
                     ],
                   )
                ],
                )
           )
           ),
           );
  }
}