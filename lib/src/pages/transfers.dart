import 'package:bettymobile/src/api/restAPI.dart';
import 'package:bettymobile/src/components/locator.dart';
import 'package:bettymobile/src/components/navService.dart';
import 'package:bettymobile/src/models/transferModel.dart';
import 'package:flutter/material.dart';

class Transfers extends StatefulWidget {
  @override
  _TransfersState createState() => _TransfersState();
}

class _TransfersState extends State<Transfers> {
   MyDataSource _tabledatasource;
  int perPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //we will use a future for now and maybe later change it to a stream
      body: StreamBuilder<List<TransferModel>>(
        stream: RestAPI.getListTransfers().asStream(),
        builder: (context, snapshot) {
          //if there is no data no need drawing the table
          if (snapshot.hasData) {
             if (snapshot.data.length == 0) {
              perPage = 0;
              return Text("No transfer has been Initiated yet");
            }
            //we plug in the data in datasource
            _tabledatasource = MyDataSource(transmodels: snapshot.data);
            if (snapshot.data.length >= 7) {
              perPage = 7;
            }
            else{
              perPage = snapshot.data.length;
            }
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: PaginatedDataTable(
                header: Text("List of Transfers"),
                dataRowHeight: 35,
                headingRowHeight: 30,
                columnSpacing: 10.0,
                horizontalMargin: 5.0,
                rowsPerPage: perPage,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('Amount Paid'),
                  ),
                  DataColumn(
                    label: Text('Paid To'),
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
          //initiate transfer
          Navigator.pushNamed(context, 'initiateTransfer');
        },
        backgroundColor: Color(0xff112b43),
        tooltip: "Initiate Transfer",
        child: Icon(
          Icons.add,
          size: 30.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MyDataSource extends DataTableSource {
  final List<TransferModel> transmodels;
  final NavigationService _navigationService = locator<NavigationService>();
  MyDataSource({this.transmodels});
  @override
  DataRow getRow(int index) {
    //a selected recipipient is the index of the list of recipients
    final TransferModel transmodel = transmodels[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
            Container(
              width: 120,
              child: Text(
                '${transmodel.amount}', 
                style: TextStyle(fontSize: 15.0),
              ),
            ), 
            onTap: () {
        //  view transfer by id
          // _navigationService.navigateTo('updateRecipient', recipientmodel);
        }
        ),
        DataCell(
          Container(
            width: 120,
            child: Text(
              '${transmodel.recipient.name}',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ),
        DataCell(
          Container(
            width: 100,
            child: Text(
              '${transmodel.dateUpdated}'.substring(0, 10),
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => transmodels.length;
  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
