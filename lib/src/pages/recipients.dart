import 'package:bettymobile/src/api/restAPI.dart';
import 'package:bettymobile/src/components/locator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:bettymobile/src/models/recipientModel.dart';
import 'package:flutter/rendering.dart';
import 'package:bettymobile/src/components/navService.dart';



class Recipients extends StatefulWidget {
  @override
  _RecipientsState createState() => _RecipientsState();
}

class _RecipientsState extends State<Recipients> {
  MyDataSource _tabledatasource;
  int perPage;

  @override
  void initState() {
    super.initState();
    // print('holla! im here again');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //we will use a future for now and maybe later change it to a stream
      body: StreamBuilder<List<RecipientModel>>(
        stream: RestAPI.getListRecipients().asStream(),
        builder: (context, snapshot) {
             
          if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
              perPage = 0;
              return Text("No transfer recipient has been created");
            }
            //we plug in the data in datasource
            _tabledatasource = MyDataSource(recipients: snapshot.data);
            if (snapshot.data.length >= 7) {
              perPage = 7;
            } else {
              perPage = snapshot.data.length;
            }
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: PaginatedDataTable(
                header: Text("Transfer Recipients"),
                dataRowHeight: 35,
                headingRowHeight: 30,
                columnSpacing: 10.0,
                horizontalMargin: 5.0,
                rowsPerPage: perPage,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('Name'),
                  ),
                  DataColumn(
                    label: Text('Description'),
                  ),
                  DataColumn(
                    label: Text('Date'),
                  )
                ],
                source: _tabledatasource,
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Color(0xff112b43),
          ));
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'registerRecipient');
        },
        backgroundColor: Color(0xff112b43),
        tooltip: "Create Transfer Recipient",
        child: Icon(
          Icons.add,
          size: 30.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

//you have to overide the default table source
class MyDataSource extends DataTableSource {
  final List<RecipientModel> recipients;
  //creating an instance of our navigation service
  final NavigationService _navigationService = locator<NavigationService>();
  MyDataSource({this.recipients});
  @override
  DataRow getRow(int index) {
    //a selected recipipient is the index of the list of recipients
    final RecipientModel recipientmodel = recipients[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
            Container(
              width: 120,
              child: Text(
                '${recipientmodel.name}', 
                style: TextStyle(fontSize: 15.0),
              ),
            ), 
            onTap: () {
        //  print(recipientmodel.recipientCode);
           _navigationService.navigateTo('updateRecipient', recipientmodel);
        }
        ),
        DataCell(
          Container(
            width: 120,
            child: Text(
              '${recipientmodel.description}',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ),
        DataCell(
          Container(
            width: 100,
            child: Text(
              '${recipientmodel.dateUpdated}'.substring(0, 10),
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => recipients.length;
  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

