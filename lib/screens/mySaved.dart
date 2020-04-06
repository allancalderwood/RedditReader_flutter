import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/user.dart';
import 'package:redditreader_flutter/styles/inputDecoration.dart';
import 'package:redditreader_flutter/utils/postFactory.dart';
import 'package:redditreader_flutter/widgets/postBuilder.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/widgets/drawer.dart';
import '../styles/theme.dart'; // import theme of app
import '../widgets/appBar.dart';

class MySaved extends StatefulWidget {
  @override
  _MySavedState createState() => _MySavedState();
}

class _MySavedState extends State<MySaved> {
  bool homepage=true;
  bool popular=false;
  TextStyle homeText = currentTheme.textTheme.headline1;
  TextStyle popularText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
  Widget currentPage;

  @override
  initState(){
    super.initState();
  }

  Future<List<Post>> _loadSaved()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/user/${User.username}/saved.json'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadSaved());
    }else{
      postFactory(jsonData, posts);
      return posts;
    }
  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: RedditReaderAppBar(),
        drawer: RedditReaderDrawer(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(0,20,0,20),
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Text('Your Saved Posts', style: currentTheme.textTheme.headline1,),
                  SizedBox(height: 80),
                  Container(
                    child: futurePostBuilderExp(_loadSaved()),
                  ),
                ],
              ),
        ),
        )
    );
  }
}
