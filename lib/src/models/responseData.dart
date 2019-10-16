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

