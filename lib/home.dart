import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:json_table/json_table.dart';
import 'package:monitoring_covid_app/api/api_login.dart';
import 'package:monitoring_covid_app/dashboard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  List<SembuhData> chartSembuh = [];
  List<PositifData> chartPositif = [];
  List<MeninggalData> chartMeninggal = [];
  var sembuh, positif, meninggal, kesimpulan;
  var errSembuh = 0, errPositif = 0, errMeninggal = 0;
  TextEditingController days;
  TextEditingController _controller = new TextEditingController();
  bool _isLoading = false;

  var hari = 7;

  Future cardData() async {
    final jsonResponse = await http
        .get('https://monitoring-covid-api.herokuapp.com/api/apps/index');
    final myJson = json.decode(jsonResponse.body);
    // print(myJson['positif']);
    setState(() {
      positif = myJson['positif'];
      sembuh = myJson['sembuh'];
      meninggal = myJson['meninggal'];
    });
  }

  Future loadSembuhData(String day) async {
    final jsonResponse = await http.post(
        'https://monitoring-covid-api.herokuapp.com/api/apps/movingAvgSembuh',
        body: {'day': day});
    final myJson = json.decode(jsonResponse.body);
    print(myJson['sembuh']);
    setState(() {
      chartSembuh.clear();
      for (Map i in myJson['sembuh']) {
        chartSembuh.add(SembuhData.fromJson(i));
      }
      errSembuh = myJson['error'];
    });
  }

  Future loadPositifData(String day) async {
    final jsonResponse1 = await http.post(
        'https://monitoring-covid-api.herokuapp.com/api/apps/movingAvgPositif',
        body: {'day': day});
    final myJson1 = json.decode(jsonResponse1.body);
    // print(myJson1);
    setState(() {
      chartPositif.clear();
      for (Map n in myJson1['positif']) {
        chartPositif.add(PositifData.fromJson(n));
      }
      errPositif = myJson1['error'];
    });
  }

  Future loadMeninggalData(String day) async {
    final jsonResponse = await http.post(
        'https://monitoring-covid-api.herokuapp.com/api/apps/movingAvgMeninggal',
        body: {'day': day});
    final myJson = json.decode(jsonResponse.body);
    // print(myJson);
    chartMeninggal.clear();
    setState(() {
      for (Map i in myJson['meninggal']) {
        chartMeninggal.add(MeninggalData.fromJson(i));
      }
      errMeninggal = myJson['error'];
    });
  }

  Future getKesimpulan() async {
    final jsonResponse = await http
        .get('https://monitoring-covid-api.herokuapp.com/api/apps/kesimpulan');
    final myJson = json.decode(jsonResponse.body);
    // print(myJson['post']);
    setState(() {
      kesimpulan = myJson['post'];
    });
  }

  var dataCovid;
  Future loadDataCovid() async {
    final jsonResponse1 = await http
        .get('https://monitoring-covid-api.herokuapp.com/api/apps/case');
    final myJson1 = json.decode(jsonResponse1.body);
    // print(myJson1);
    if (myJson1 != 0) {
      setState(() {
        dataCovid = myJson1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadSembuhData("7");
    loadPositifData("7");
    loadMeninggalData("7");
    cardData();
    getKesimpulan();
    loadDataCovid();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Monitoring Covid'),
            ),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                height: 180,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: <Widget>[
                              Material(
                                  color: Colors.blueAccent,
                                  shape: CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.sentiment_satisfied_alt,
                                        color: Colors.white, size: 30.0),
                                  )),
                              Text('Sembuh',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0)),
                              Text(sembuh ?? '',
                                  style: TextStyle(color: Colors.black45)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: <Widget>[
                                Material(
                                    color: Colors.blueAccent,
                                    shape: CircleBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(Icons.local_hospital,
                                          color: Colors.white, size: 30.0),
                                    )),
                                Text('Positif',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24.0)),
                                Text(positif ?? '',
                                    style: TextStyle(color: Colors.black45)),
                              ],
                            )),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: <Widget>[
                                Material(
                                    color: Colors.blueAccent,
                                    shape: CircleBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(Icons.airline_seat_flat,
                                          color: Colors.white, size: 30.0),
                                    )),
                                Text('Meninggal',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24.0)),
                                Text(meninggal ?? '',
                                    style: TextStyle(color: Colors.black45)),
                              ],
                            )),
                      ]),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Card(
                  child: Html(
                    data: kesimpulan ?? '',
                  ),
                  elevation: 5.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 250,
                    height: 100,
                    margin: EdgeInsets.only(top: 5),
                    child: TextFormField(
                      autofocus: false,
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Jumlah Hari',
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      " Cek",
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      print('hari ${_controller.text}');
                      loadSembuhData(_controller.text);
                      loadPositifData(_controller.text);
                      loadMeninggalData(_controller.text);
                    },
                    color: Colors.greenAccent,
                    textColor: Colors.white,
                    splashColor: Colors.grey,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                // height: 200.0,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          // Chart title
                          title: ChartTitle(text: 'Moving Average (Sembuh)'),
                          // Enable legend
                          // legend: Legend(isVisible: true),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<SembuhData, String>>[
                            LineSeries<SembuhData, String>(
                                dataSource: chartSembuh,
                                xValueMapper: (SembuhData sales, _) =>
                                    sales.year,
                                yValueMapper: (SembuhData sales, _) =>
                                    sales.sales,
                                // Enable data label
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true))
                          ]),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                              'Error:' + (errSembuh.abs() ?? 0).toString())),
                    ],
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.all(10.0),
                  // height: 200.0,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            // Chart title
                            title: ChartTitle(text: 'Moving Average (Positif)'),
                            // Enable legend
                            // legend: Legend(isVisible: true),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<PositifData, String>>[
                              LineSeries<PositifData, String>(
                                  dataSource: chartPositif,
                                  xValueMapper: (PositifData sales, _) =>
                                      sales.year,
                                  yValueMapper: (PositifData sales, _) =>
                                      sales.sales,
                                  // Enable data label
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true))
                            ]),
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                                'Error:' + (errPositif.abs() ?? 0).toString())),
                      ],
                    ),
                  )),
              Container(
                  margin: EdgeInsets.all(10.0),
                  // height: 200.0,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            // Chart title
                            title:
                                ChartTitle(text: 'Moving Average (Meninggal)'),
                            // Enable legend
                            // legend: Legend(isVisible: true),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<MeninggalData, String>>[
                              LineSeries<MeninggalData, String>(
                                  dataSource: chartMeninggal,
                                  xValueMapper: (MeninggalData sales, _) =>
                                      sales.year,
                                  yValueMapper: (MeninggalData sales, _) =>
                                      sales.sales,
                                  // Enable data label
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true))
                            ]),
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Text('Error:' +
                                (errMeninggal.abs() ?? 0).toString())),
                      ],
                    ),
                  )),
              Card(
                child: JsonTable(dataCovid),
                elevation: 5,
              ),
            ],
          )),
        ),
      ),
    );
  }
}

class SembuhData {
  SembuhData(this.year, this.sales);

  final String year;
  final int sales;

  factory SembuhData.fromJson(Map<String, dynamic> parsedJson) {
    return SembuhData(
      parsedJson['date'].toString(),
      parsedJson['sembuh'] as int,
    );
  }
}

class PositifData {
  PositifData(this.year, this.sales);

  final String year;
  final int sales;

  factory PositifData.fromJson(Map<String, dynamic> parsedJson) {
    return PositifData(
      parsedJson['date'].toString(),
      parsedJson['positif'] as int,
    );
  }
}

class MeninggalData {
  MeninggalData(this.year, this.sales);

  final String year;
  final int sales;

  factory MeninggalData.fromJson(Map<String, dynamic> parsedJson) {
    return MeninggalData(
      parsedJson['date'].toString(),
      parsedJson['meninggal'] as int,
    );
  }
}
