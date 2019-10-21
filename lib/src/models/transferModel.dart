class TransferList {
  final List<TransferModel> transferModels;
  TransferList({this.transferModels});

  factory TransferList.fromJson(List<dynamic> jsonData) {
    List<TransferModel> transfermodels = new List<TransferModel>();
    transfermodels = jsonData.map((i) => TransferModel.fromJson(i)).toList();
    return TransferList(transferModels: transfermodels);
  }
}

class TransferModel {
  final int amount;
  final String source;
  final String reason;
  final int id;
  final String transfercode;
  final String otp;
  //unmapped
  final String recipientcode;
  final String currency;
  final String reference;
  final String failures;
  final String dateUpdated;
  final String status;
  final dynamic recipient;

  TransferModel(
      {this.amount,
      this.source,
      this.reason,
      this.id,
      this.transfercode,
      this.otp,
      this.recipientcode,
      this.currency,
      //reference is not mapped
      this.reference,
      this.failures,
      this.dateUpdated,
      this.status,
      this.recipient});

  factory TransferModel.fromJson(Map<String, dynamic> jsonData) {
    Recipient _recipient = Recipient.fromJson(jsonData['recipient']);
    return TransferModel(
      amount: jsonData['amount'],
      source: jsonData['source'],
      reason: jsonData['reason'],
      id: jsonData['id'],
      transfercode: jsonData['transfer_code'],
      recipientcode: jsonData['recipient_code'],
      currency: jsonData['currency'],
      failures: jsonData['failures'],
      dateUpdated: jsonData['updatedAt'],
      status: jsonData['status'],
      recipient: _recipient
    );
  }
}

class Recipient {
  final String name;
  final String recipientcode;
  final String id;
  final String dateUpdated;

  Recipient({this.name, this.recipientcode, this.id, this.dateUpdated});

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
        name: json['name'],
        recipientcode: json['recipient_code'],
        id: json['id'],
        dateUpdated: json['updatedAt']);
  }
}
