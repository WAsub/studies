
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiResults {
  final String message;
  final dynamic data;
  ApiResults({
    this.message,
    this.data,
  });
  factory ApiResults.errorMsg(String msg) {
    return ApiResults(message: msg, data: null);
  }
  factory ApiResults.fromJson(Map<String, dynamic> json) {
    return ApiResults(message: json['message'], data: json['data']);
  }
}

Future<ApiResults> fetchApiResults(url, requestMap) async {
  return ApiResults.errorMsg("Failed");//TODO APIができるまで
  var response;
  try{
    response = await http.post(url, body: json.encode(requestMap), headers: {"Content-Type": "application/json"});
  }on SocketException catch(e){
    response.statusCode = 410;
  }on Exception catch(e){
    response.statusCode = 411;
  }
  

  if (response.statusCode == 200) {
    return ApiResults.fromJson(json.decode(response.body));
  } else {
    return ApiResults.errorMsg("Failed");
    // throw Exception('Failed');
  }
}