import 'package:bettymobile/src/models/transferModel.dart';
import 'package:flutter/material.dart';

class ViewTransfer extends StatefulWidget {
  final TransferModel model;
  ViewTransfer(this.model);
  @override
  _ViewTransferState createState() => _ViewTransferState(this.model);
}

class _ViewTransferState extends State<ViewTransfer> {
  TransferModel model;
  _ViewTransferState(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}