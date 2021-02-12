import 'package:frontend/middleware/helpers.dart';
import 'dart:io' show Platform;

class Userware {
  String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:8090/user/"
      : "http://localhost:8090/user/";
  Future<Map<String, dynamic>> register(username, email, password) async {
    String url = baseUrl + "register";
    return await postRequest(url,
        headers: baseHeaders,
        data: {'username': username, 'email': email, 'password': password});
  }

  Future<Map<String, dynamic>> login(username, password) async {
    String url = baseUrl + "login";
    return await postRequest(url,
        headers: baseHeaders,
        data: {'username': username, 'password': password});
  }

  Future<Map<String, dynamic>> validate(username, password, code) async {
    String url = baseUrl + "validate";
    return await postRequest(url,
        headers: baseHeaders,
        data: {'username': username, 'password': password, 'code': code});
  }

  Future<Map<String, dynamic>> getManga(String jwt) async {
    String url = baseUrl + "getManga";
    return await postRequest(url, headers: jwtHeaders(jwt), data: null);
  }

  Future<Map<String, dynamic>> favoriteManga(
    String jwt,
    manga,
  ) async {
    String url = baseUrl + "favoriteManga";
    return await postRequest(
      url,
      headers: jwtHeaders(jwt),
      data: {'manga': manga['title']},
    );
  }

  Future<Map<String, dynamic>> ignoreManga(
    String jwt,
    manga,
  ) async {
    String url = baseUrl + "ignoreManga";
    return await postRequest(
      url,
      headers: jwtHeaders(jwt),
      data: {'manga': manga['title']},
    );
  }

  Future<Map<String, dynamic>> suggestManga(String jwt) async {
    String url = baseUrl + "suggestManga";
    return await postRequest(
      url,
      headers: jwtHeaders(jwt),
    );
  }
}
