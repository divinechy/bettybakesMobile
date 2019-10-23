import 'dart:convert';
import 'package:bettymobile/src/models/bankModel.dart';
import 'package:bettymobile/src/models/recipientModel.dart';
import 'package:bettymobile/src/models/responseData.dart';
import 'package:bettymobile/src/models/transferModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class RestAPI {
  static Future<void> saveToken(String tk) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', tk);
    } catch (e) {
      throw e;
    }
  }

  static getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var tk = pref.getString('token');
    return tk;
  }

  static Future<BankList> getListBanks() async {
    try {
      var token = await getToken();
      var url = "https://api.paystack.co/bank";
      var response = await http.get(url, headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "bearer $token"
      });
      var res = ResponseData.fromJson(json.decode(response.body));
      if (res.status == true) {
        var result = BankList.fromJson(res.data);
        return result;
      } else
        throw res.message;
    } catch (e) {
      if (e.runtimeType == String) {
        throw e;
      } else
        throw e.message;
    }
  }

  static Future<List<RecipientModel>> getListRecipients() async {
    try {
      var token = await getToken();
      var url = "https://api.paystack.co/transferrecipient";
      var response = await http.get(url, headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "bearer $token"
      });
      var res = ResponseData.fromJson(json.decode(response.body));
      if (res.status == true) {
        var result = RecipientList.fromJson(res.data);
        return result.recipientModels;
      } else
        throw res.message;
    } catch (e) {
      if (e.runtimeType == String) {
        throw e;
      } else
        throw e.message;
    }
  }

  static Future<String> createRecipient(RecipientModel _recipient) async {
    try {
      var token = await getToken();
      var url = "https://api.paystack.co/transferrecipient";
      var response = await http.post(url,
          body: json.encode({
            "type": _recipient.type,
            "name": _recipient.name,
            "account_number": _recipient.accountnumber,
            "bank_code": _recipient.bankcode,
            "currency": _recipient.currency,
            "description": _recipient.description
          }),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            HttpHeaders.authorizationHeader: "bearer $token"
          });
      var res = ResponseData.fromJson(json.decode(response.body));
      if (res.status == true) {
        var msg = "recipient created successfully";
        return msg;
      } else
        throw res.message;
    } catch (e) {
      //only interested in the exception message
      if (e.runtimeType == String) {
        throw e;
      } else
        throw e.message;
    }
  }

  static Future<String> updateRecipient(
      RecipientModel _recipient, int id) async {
    try {
      var token = await getToken();
      var url = "https://api.paystack.co/transferrecipient/$id";
      var response = await http.put(url,
          body: json.encode({
            "name": _recipient.name,
            "email": _recipient.email,
          }),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            HttpHeaders.authorizationHeader: "bearer $token"
          });
      var res = ResponseData.fromJson(json.decode(response.body));
      if (res.status == true) {
        var msg = "recipient updated successfully";
        return msg;
      } else
        throw res.message;
    } catch (e) {
      if (e.runtimeType == String) {
        throw e;
      } else
        throw e.message;
    }
  }

  static Future<String> deleteRecipient(int id) async {
    try {
      var token = await getToken();
      var url = "https://api.paystack.co/transferrecipient/$id";
      var response = await http.delete(url, headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "bearer $token"
      });
      var res = ResponseData.fromJson(json.decode(response.body));
      if (res.status == true) {
        var msg = "recipient deleted successfully";
        return msg;
      } else
        throw res.message;
    } catch (e) {
      if (e.runtimeType == String) {
        throw e;
      } else
        throw e.message;
    }
  }

  static Future<List<TransferModel>> getListTransfers() async {
    try {
      var token = await getToken();
       var url = "https://api.paystack.co/transfer";
      var response = await http.get(url, headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "bearer $token"
      });
      var res = ResponseData.fromJson(json.decode(response.body));
      if (res.status == true) {
        var result = TransferList.fromJson(res.data);
        return result.transferModels;
      } else
        throw res.message;
    } catch (e) {
      if (e.runtimeType == String) {
        throw e;
      } else
        throw e.message;
    }
  }

  static Future<String> initiateTransfer(TransferModel _transfer) async {
    try {
      var token = await getToken();
      var url = "https://api.paystack.co/transfer";
      var response = await http.post(url,
          body: json.encode({
            "source": _transfer.source,
            "amount": _transfer.amount,
            "currency": _transfer.currency,
            "reason": _transfer.reason,
            "recipient": _transfer.recipientcode,
            "reference": _transfer.reference
          }),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            HttpHeaders.authorizationHeader: "bearer $token"
          });
      var res = ResponseData.fromJson(json.decode(response.body));
      if (res.status == true) {
        var msg = "Transfer initiated successfully";
        return msg;
      } else
        throw res.message;
    } catch (e) {
      //only interested in the exception message
      if (e.runtimeType == String) {
        throw e;
      } else
        throw e.message;
    }
  }

 static Future<TransferModel> getTransferById(int id) async {
    try {
      var token = await getToken();
      var url = "https://api.paystack.co/transfer/$id";
      var response = await http.get(url, headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "bearer $token"
      });
      var res = ResponseData.fromJson(json.decode(response.body));
      if (res.status == true) {
        var result = TransferModel.fromJson(res.data);
        return result;
      } else
        throw res.message;
    } catch (e) {
      if (e.runtimeType == String) {
        throw e;
      } else
        throw e.message;
    }
  }

   static Future<String> finalizeTransfer(TransferModel _transfer) async {
    try {
      var token = await getToken();
      var url = "https://api.paystack.co/transfer/finalize_transfer";
      var response = await http.post(url,
          body: json.encode({
            "transfer_code": _transfer.transfercode,
            "otp": _transfer.otp,
          }),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            HttpHeaders.authorizationHeader: "bearer $token"
          });
      var res = ResponseData.fromJson(json.decode(response.body));
      if (res.status == true) {
        var msg = "Transfer completed successfully";
        return msg;
      } else
        throw res.message;
    } catch (e) {
      //only interested in the exception message
      if (e.runtimeType == String) {
        throw e;
      } else
        throw e.message;
    }
  }

  static Future<List<BalanceDatum>> checkBalance() async {
    try {
      var token = await getToken();
      var url = "https://api.paystack.co/balance";
      var response = await http.get(url, headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "bearer $token"
      });
      var res = ResponseData.fromJson(json.decode(response.body));
      if (res.status == true) {
        var result = BalanceDataList.fromJson(res.data);
        return result.balanceData;
      } else
        throw res.message;
    } catch (e) {
      if (e.runtimeType == String) {
        throw e;
      } else
        throw e.message;
    }
  }
}
