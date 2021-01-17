import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_covid_app/api/getHome.dart';
import 'package:monitoring_covid_app/detail.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
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

  GetHome getHome;
  @override
  void initState() {
    getHome = GetHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GetHome().getProfiles().then((value) => print("value: $value"));
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tips'),
          backgroundColor: Colors.greenAccent,
        ),
        body: FutureBuilder(
          future: getHome.getProfiles(),
          builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Data> profiles = snapshot.data;
              return _buildListView(profiles);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<Data> profiles) {
    return profiles.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
              itemBuilder: (context, index) {
                Data profile = profiles[index];
                return Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(6),
                                          bottomLeft: Radius.circular(6))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 4,
                                      ),
                                      new InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailPost(
                                                        text: profile.judul,
                                                        text2: profile.post),
                                              ));
                                        },
                                        child: new Padding(
                                          padding: new EdgeInsets.all(10.0),
                                          child: new Text(
                                            profile.judul ?? '',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: profiles.length,
            ),
            onRefresh: () => getHome.getProfiles(),
          )
        : Center(child: CircularProgressIndicator());
  }
}
