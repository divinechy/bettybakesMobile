class BankList{

   final List<BankModel> bankModels;
   BankList({this.bankModels});

   factory BankList.fromJson(List<dynamic>jsonData){
    List<BankModel> bankmodels = new List<BankModel>();
    bankmodels = jsonData.map((i)=>BankModel.fromJson(i)).toList();
      return BankList(
        bankModels: bankmodels
      );
  }
}

class BankModel{
  String name;
  String code;
  String country;
  String currency;
  String type;

  BankModel({this.name, this.code, this.country, this.currency, this.type
  });

  factory BankModel.fromJson(Map<String, dynamic>jsonData){
    return BankModel(
     name: jsonData['name'],
     code: jsonData['code'],
     country: jsonData['country'],
     currency: jsonData['currency'],
     type: jsonData['type']
    );
  }
}
