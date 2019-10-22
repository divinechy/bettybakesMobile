import 'package:bettymobile/src/api/restAPI.dart';
import 'package:bettymobile/src/pages/recipients.dart';
import 'package:bettymobile/src/pages/transfers.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  int recipientsCount;
  int transfersCount;

  @override
  void initState() {
    super.initState();
    RestAPI.getListRecipients().then((result) {
      setState(() {
        recipientsCount = result.length;
      });
    });
    RestAPI.getListTransfers().then((res) {
      setState(() {
        transfersCount = res.length;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget getHomeItems = isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xff112b43),
            ),
          )
        : Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  margin: EdgeInsets.all(15),
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
                              'images/blackwomen.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 170,
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 10,
                            child: Container(
                              width: 300,
                              color: Colors.black54,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Text(
                                '$recipientsCount Recipient(s)',
                                style: TextStyle(
                                    fontSize: 26, color: Colors.white),
                                softWrap: true,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          )
                        ],
                      ),
                      
                    ],
                  ),
                ),
                 Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  margin: EdgeInsets.all(15),
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
                              'images/creditcard.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 170,
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 10,
                            child: Container(
                              width: 300,
                              color: Colors.black54,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Text(
                                '$transfersCount Transfer(s)',
                                style: TextStyle(
                                    fontSize: 26, color: Colors.white),
                                softWrap: true,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              
              ],
            ),
          );
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: getHomeItems,
      ),
    );
  }
}
