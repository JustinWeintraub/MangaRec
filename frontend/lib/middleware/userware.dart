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

  favoriteManga(
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

  suggestManga(String jwt) async {
    String url = baseUrl + "suggestManga";
    return await postRequest(
      url,
      headers: jwtHeaders(jwt),
    );
  }
}
