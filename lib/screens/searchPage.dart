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
import 'package:redditreader_flutter/widgets/subSearchBuilder.dart';
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

  @override
  initState(){
  }

  Future<List<Subreddit>> _loadSubs()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/search.json?limit=6&q=${widget.search}&type=sr'), headers: getHeader());
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
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/search.json?limit=30&q=${widget.search}&type=link'), headers: getHeader());
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
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/search.json?limit=6&q=${widget.search}&type=user'), headers: getHeader());
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
        body: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text('Results', style: currentTheme.textTheme.headline1,),
                    SizedBox(height: 40),
                    Container(
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
                          SizedBox(height: 10,),
                          futurePostBuilder(_loadPosts()),
                        ],
                      ),
                    ),
                  ],
                ),
              )
        )
    );
  }
}
