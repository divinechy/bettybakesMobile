class RecipientList {
  final List<RecipientModel> recipientModels;
  RecipientList({this.recipientModels});

  factory RecipientList.fromJson(List<dynamic> jsonData) {
    List<RecipientModel> recipientmodels = new List<RecipientModel>();
    recipientmodels = jsonData.map((i) => RecipientModel.fromJson(i)).toList();
    return RecipientList(recipientModels: recipientmodels);
  }
}

class RecipientModel {
  final String name;
  final String type;
  //accountnumber here is not mapped
  final String accountnumber;
  final int id;
  final dynamic details;
  final String bankcode;
  final String currency;
  final String description;
  final String email;
  final String dateUpdated;
  final String recipientCode;
  final bool isDeleted;

  RecipientModel(
      {this.name,
      this.type,
      this.accountnumber,
      this.id,
      this.details,
      this.bankcode,
      this.currency,
      this.description,
      this.email,
      this.dateUpdated,
      this.recipientCode,
      this.isDeleted});

  factory RecipientModel.fromJson(Map<String, dynamic> jsonData) {
      Details _detail = Details.fromJson(jsonData['details']);
    return RecipientModel(
        name: jsonData['name'],
        type: jsonData['type'],
        id: jsonData['id'],
        details: _detail,
        bankcode: jsonData['bank_code'],
        currency: jsonData['currency'],
        description: jsonData['description'],
        email: jsonData['email'],
        dateUpdated: jsonData['updatedAt'],
        recipientCode: jsonData['recipient_code'],
        isDeleted: jsonData['is_deleted']);
  }
}

class Details {
  final String authorizationcode;
  final String accountnumber;
  final String accountname;
  final String bankcode;
  final String bankname;

  Details(
      {this.authorizationcode,
      this.accountnumber,
      this.accountname,
      this.bankcode,
      this.bankname});

      factory Details.fromJson(Map<String, dynamic> json){
        return Details(
          authorizationcode: json['authorization_code'],
          accountnumber: json['account_number'],
          accountname: json['account_name'],
          bankcode: json['bank_code'],
          bankname: json['bank_name']
        );
      }
}
