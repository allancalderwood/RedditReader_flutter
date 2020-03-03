import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:redditreader_flutter/models/trophy.dart';
import 'dart:convert';
import 'package:redditreader_flutter/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/subreddit.dart';
import 'package:redditreader_flutter/screens/subredditPage.dart';
import 'package:redditreader_flutter/styles/theme.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:share/share.dart';

Widget futureTrophyBuilder(Future<List<Trophy>> future){
  return FutureBuilder<List<Trophy>>(
    future: future,
    builder: (context, snapshot){
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
        return Container(
            child: Center(
              child: CircularProgressIndicator(backgroundColor: currentTheme.primaryColor,),
            )
        );
        default:
          if (snapshot.hasError)
            return Column(
            children: <Widget>[
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Can't load Trophies right now.", style: currentTheme.textTheme.headline2,)
                ],
              ),
            ],
          );
          else
            return Card(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5,30,5,5),
                child: Column(
                  children: <Widget>[
                    Text('Trophies', style: currentTheme.textTheme.headline1,),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return trophyWidget(trophy: snapshot.data[index]);
                      },
                    ),
                  ],
                ),
              )
            );
      }
    },
  );
}

class trophyWidget extends StatefulWidget{
  trophyWidget({Key key, this.trophy}) : super(key: key);
  final Trophy trophy;

  @override
  _trophyWidgetState createState() => _trophyWidgetState();
}

class _trophyWidgetState extends State<trophyWidget> {
  @override
  void initState() {
    super.initState();
  }


  // content of the screen
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeInImage(
              image: NetworkImage(widget.trophy.iconUrl),
              placeholder: AssetImage('assets/images/logo'),
              height: 70,//(p.imageHeight>500) ? ((p.imageHeight.toDouble()) /2) : p.imageHeight.toDouble(),
              width: 70, //(p.imageHeight>500) ? ((p.imageWidth.toDouble()) /2) : p.imageWidth.toDouble(),
            ),
            SizedBox(width: 30,),
            Text('${widget.trophy.name}', style: currentTheme.textTheme.headline2,)
          ],
        ),
        SizedBox(height: 30,)
      ],
    );
  }
}