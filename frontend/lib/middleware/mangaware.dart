import 'dart:convert';
import 'package:frontend/middleware/helpers.dart';
import 'dart:io' show Platform;

class Mangaware {
  String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:8090/manga/"
      : "http://localhost:8090/manga/";
  Future<Map<String, dynamic>> getAll(jwt) async {
    //TODO
    String url = baseUrl + "getAll";
    return getRequest(url, headers: jwtHeaders(jwt));
  }

  dynamic getCover(jwt, id) async {
    //TODO
    String url = baseUrl + 'getCover/' + id;
    var response = await getRequest(url, headers: jwtHeaders(jwt));
    if (response['body'] == null) return response;
    Map decodedBody = await jsonDecode(response['body']);
    return base64
        .decode(base64.encode(decodedBody['Body']['data'].cast<int>()));
  }

  getManga(jwt, manga) async {
    String url = baseUrl + "getManga";
    return await postRequest(url,
        headers: jwtHeaders(jwt), data: {'manga': manga});
  }
}
