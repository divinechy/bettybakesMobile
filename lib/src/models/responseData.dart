class ResponseData{
 bool status;
 String message;
 dynamic data;

  ResponseData({
    this.status,
    this.message,
    this.data
  });

   factory ResponseData.fromJson(Map<String, dynamic>parsedJson){
     return ResponseData(
       status: parsedJson['status'],
       message: parsedJson['message'],
       data: parsedJson['data'],
     );
   }
}
//this data is a list of dynamics to recieve acct balance from json
class BalanceDataList{
  final List<BalanceDatum> balanceData;
  BalanceDataList({this.balanceData});

  factory BalanceDataList.fromJson(List<dynamic> jsonData) {
    List<BalanceDatum> datas = new List<BalanceDatum>();
    datas = jsonData.map((i) => BalanceDatum.fromJson(i)).toList();
    return BalanceDataList(balanceData: datas);
  }
}

class BalanceDatum{
  final String currency;
  final int balance;

  BalanceDatum({this.currency, this.balance});

  factory BalanceDatum.fromJson(Map<String, dynamic> jsonData){
    return BalanceDatum(
      currency: jsonData['currency'],
      balance: jsonData['balance']
    );
  }
}
