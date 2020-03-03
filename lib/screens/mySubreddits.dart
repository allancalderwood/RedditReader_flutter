import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/subreddit.dart';
import 'package:redditreader_flutter/models/user.dart';
import 'package:redditreader_flutter/styles/inputDecoration.dart';
import 'package:redditreader_flutter/utils/postFactory.dart';
import 'package:redditreader_flutter/utils/subFactory.dart';
import 'package:redditreader_flutter/widgets/postBuilder.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/widgets/drawer.dart';
import 'package:redditreader_flutter/widgets/subBuilder.dart';
import '../styles/theme.dart'; // import theme of app
import '../widgets/appBar.dart';

class MySubreddits extends StatefulWidget {
  @override
  _MySubredditsState createState() => _MySubredditsState();
}

class _MySubredditsState extends State<MySubreddits> {
  bool homepage=true;
  bool popular=false;
  TextStyle homeText = currentTheme.textTheme.headline1;
  TextStyle popularText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
  Widget currentPage;

  @override
  initState(){
  }

  Future<List<Subreddit>> _loadSubs()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/subreddits/mine/subscriber.json?limit=1000'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Subreddit> subs = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadSubs());
    }else{
      subFactory(jsonData, subs);
      subs.sort((a,b)=> a.name.toUpperCase().compareTo(b.name.toUpperCase()));
      return subs;
    }
  }


  // content of the screen
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: RedditReaderAppBar(),
        drawer: RedditReaderDrawer(),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Text('Your Subreddits', style: currentTheme.textTheme.headline1,),
                  SizedBox(height: 80),
                  Container(
                    child: futureSubBuilder(_loadSubs()),
                  ),
                ],
              ),
            ),
        )
    );
  }
}
