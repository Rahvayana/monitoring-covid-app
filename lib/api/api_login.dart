import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  final String _url = 'https://nayaku-api.herokuapp.com/';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
