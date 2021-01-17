import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';

class DetailPost extends StatefulWidget {
  final String text, text2;
  DetailPost({Key key, @required this.text, @required this.text2})
      : super(key: key);
  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.text ?? ''),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  widget.text,
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Html(
                  data: widget.text2,
                  //Optional parameters:
                  customRender: {
                    "flutter":
                        (RenderContext context, Widget child, attributes, _) {
                      return FlutterLogo(
                        style: (attributes['horizontal'] != null)
                            ? FlutterLogoStyle.horizontal
                            : FlutterLogoStyle.markOnly,
                        textColor: context.style.color,
                        size: context.style.fontSize.size * 5,
                      );
                    },
                  },
                ),
              ],
            ),
          ),
          elevation: 5.0,
        ),
      ),
    );
  }
}
