import 'package:frontend/middleware/helpers.dart';

class Userware {
  String baseUrl = "http://localhost:8090/user/";
  Future<Map<String, dynamic>> register(name, pass) async {
    String url = baseUrl + "register";
    return await postRequest(url,
        headers: baseHeaders, data: {'username': name, 'password': pass});
  }

  Future<Map<String, dynamic>> login(name, pass) async {
    String url = baseUrl + "login";
    return await postRequest(url,
        headers: baseHeaders, data: {'username': name, 'password': pass});
  }

  Future<Map<String, dynamic>> getManga(String jwt) async {
    String url = baseUrl + "getManga";
    return await postRequest(url, headers: jwtHeaders(jwt), data: null);
  }

  changeManga(String jwt, manga, bool added) async {
    String url = baseUrl + (added ? "removeManga" : "addManga");
    return await postRequest(
      url,
      headers: jwtHeaders(jwt),
      data: {'manga': manga['title']},
    );
  }

  suggestManga(String jwt) async {
    String url = baseUrl + "suggestManga";
    return await postRequest(
      url,
      headers: jwtHeaders(jwt),
    );
  }
}
