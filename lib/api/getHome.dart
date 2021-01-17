import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;

class Data {
  int id;
  String judul;
  String post;

  Data({this.id, this.judul, this.post});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(id: json['id'], judul: json['judul'], post: json['post']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "judul": judul,
      "post": post,
    };
  }

  @override
  String toString() {
    return 'Data{id: $id, name: $judul, email: $post}';
  }
}

List<Data> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Data>.from(data.map((item) => Data.fromJson(item)));
}

String profileToJson(Data data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class GetHome {
  Client client = Client();

  Future<List<Data>> getProfiles() async {
    final response = await client
        .get("https://monitoring-covid-api.herokuapp.com/api/apps/posts");
    if (response.statusCode == 200) {
      print(response.body);
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }
}
