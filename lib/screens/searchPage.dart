import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/subreddit.dart';
import 'package:redditreader_flutter/models/userOther.dart';
import 'package:redditreader_flutter/utils/postFactory.dart';
import 'package:redditreader_flutter/utils/subFactory.dart';
import 'package:redditreader_flutter/utils/userFactory.dart';
import 'package:redditreader_flutter/widgets/postBuilder.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/widgets/drawer.dart';
import 'package:redditreader_flutter/widgets/subBuilder.dart';
import 'package:redditreader_flutter/widgets/userSearchBuilder.dart';

import '../styles/theme.dart'; // import theme of app
import '../widgets/appBar.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.search}) : super(key: key);
  final String search;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool subs;
  bool users;
  bool posts;
  Widget currentPage;
  TextStyle postText = currentTheme.textTheme.headline1;
  TextStyle usersText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
  TextStyle subsText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);

  @override
  initState(){
     subs = false;
     users = false;
     posts = true;
     currentPage = futurePostBuilder(_loadPosts());
  }

  void postsClick(){
    if(!posts){
      posts=true;
      users=false;
      subs = false;
      setState(() {
        postText = currentTheme.textTheme.headline1;
        usersText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
        subsText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
        currentPage = futurePostBuilder(_loadPosts());
      });
    }
  }

  void subsClick(){
    if(!subs){
      subs=true;
      users=false;
      posts = false;
      setState(() {
        subsText = currentTheme.textTheme.headline1;
        usersText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
        postText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
        currentPage = futureSubBuilder(_loadSubs());
      });
    }
  }

  void usersClick(){
    if(!users){
      users=true;
      subs=false;
      posts = false;
      setState(() {
        usersText = currentTheme.textTheme.headline1;
        subsText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
        postText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
        currentPage = futureUserSearchBuilder(_loadUsers());
      });
    }
  }

  Future<List<Subreddit>> _loadSubs()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/search.json?limit=100&q=${widget.search}&type=sr'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Subreddit> subs = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadSubs());
    }else{
      subFactory(jsonData, subs);
      return subs;
    }
  }

  Future<List<Post>> _loadPosts()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/search.json?limit=100&q=${widget.search}&type=link'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadPosts());
    }else{
      postFactory(jsonData, posts);
      return posts;
    }
  }

  Future<List<UserOther>> _loadUsers()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/search.json?limit=100&q=${widget.search}&type=user'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<UserOther> users = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadUsers());
    }else{
      userFactory(jsonData, users);
      print('RR: $jsonData');
      return users;
    }
  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: RedditReaderAppBar(),
        drawer: RedditReaderDrawer(),
        body: Column(
          children: <Widget>[
            SizedBox(height: 30,),
            Text("Results for '${widget.search}'", style: (widget.search.length<10)? currentTheme.textTheme.headline1 : currentTheme.textTheme.headline2),
            SizedBox(height: 10,),
            Row(
              children: <Widget>[
                SizedBox(height: 120,),
                FlatButton(
                    onPressed: postsClick,
                    child: Text('Posts', style: postText)
                ),
                FlatButton(
                  onPressed: subsClick,
                  child:
                  Text('Subreddits', style: subsText),
                ),
                FlatButton(
                  onPressed: usersClick,
                  child:
                  Text('Users', style: usersText),
                ),
              ],
            ),
            currentPage
          ],
        )
    );
  }
}


// Text('Results', style: currentTheme.textTheme.headline1,),

/* Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Subreddits:', style: currentTheme.textTheme.headline2,),
                          SizedBox(height: 10,),
                          futureSubSearchBuilder(_loadSubs()),
                          SizedBox(height: 30,),
                          Text('Users:', style: currentTheme.textTheme.headline2,),
                          SizedBox(height: 10,),
                          futureUserSearchBuilder(_loadUsers()),
                          SizedBox(height: 30,),
                          Text('Posts:', style: currentTheme.textTheme.headline2,),
                          //SizedBox(height: 10,),
                          //futurePostBuilder(_loadPosts()),
                        ],
                      ),
                    ),*/
