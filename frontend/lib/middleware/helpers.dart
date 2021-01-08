import 'dart:convert';

import 'package:http/http.dart' as http;

Map<String, dynamic> genericError = {
  'success': false,
  'message': 'An unexpected error occured.'
};
Map<String, String> baseHeaders = {"Content-Type": "application/json"};
Map<String, String> jwtHeaders(String jwt) {
  return {"Content-Type": "application/json", "authorization": jwt};
}

Future<Map<String, dynamic>> postRequest(String url,
    {Map<String, String> headers, Map<String, dynamic> data}) async {
  try {
    dynamic body = data == null ? null : json.encode(data);
    dynamic response = await http.post(url, headers: headers, body: body);
    return await jsonDecode(response.body);
  } catch (e) {
    return genericError;
  }
}

Future<Map<String, dynamic>> getRequest(String url,
    {Map<String, String> headers}) async {
  try {
    dynamic response = await http.get(url, headers: headers);
    return await jsonDecode(response.body);
  } catch (e) {
    return genericError;
  }
}
