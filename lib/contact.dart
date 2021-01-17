import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  var provinsi, kabupaten;
  Future loadProvinsiData() async {
    final jsonResponse1 = await http.get(
        'https://monitoring-covid-api.herokuapp.com/api/apps/contactProvinsi');
    final myJson1 = json.decode(jsonResponse1.body);
    print(myJson1);
    if (myJson1 != 0) {
      setState(() {
        provinsi = myJson1;
      });
    }
  }

  Future loadKabupatenData() async {
    final jsonResponse1 = await http.get(
        'https://monitoring-covid-api.herokuapp.com/api/apps/contactKabupaten');
    final myJson1 = json.decode(jsonResponse1.body);
    print(myJson1);
    if (myJson1 != 0) {
      setState(() {
        kabupaten = myJson1;
      });
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Apa anda Yakin?'),
            content: new Text('Anda akan keluar dari aplikasi ini'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    loadProvinsiData();
    loadKabupatenData();
  }

  @override
  Widget build(BuildContext context) {
    if (kabupaten == null || provinsi == null) {
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Contacts'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            )),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Contacts'),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Card(
                child: JsonTable(provinsi),
                elevation: 5,
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                child: JsonTable(kabupaten),
                elevation: 5,
              )
            ],
          )));
    }
  }
}
