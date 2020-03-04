import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/post.dart';

import 'package:redditreader_flutter/utils/postFactory.dart';

import 'package:redditreader_flutter/widgets/postBuilder.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/widgets/drawer.dart';


import '../styles/theme.dart'; // import theme of app
import '../widgets/appBar.dart';

class SearchSubredditPage extends StatefulWidget {
  SearchSubredditPage({Key key, this.search, this.sub}) : super(key: key);
  final String search;
  final String sub;
  @override
  _SearchSubredditPageState createState() => _SearchSubredditPageState();
}

class _SearchSubredditPageState extends State<SearchSubredditPage> {

  @override
  initState(){
  }


  Future<List<Post>> _loadSubPosts()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/r/${widget.sub}/search.json?limit=100&q=${widget.search}&type=link&restrict_sr=on'), headers: getHeader());
    var jsonData = json.decode(data.body);
    print('RR: $jsonData');
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadSubPosts());
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
                          SizedBox(height: 30,),
                          Text('Posts found on this subreddit:', style: currentTheme.textTheme.headline3,),
                          SizedBox(height: 10,),
                          futurePostBuilder(_loadSubPosts()),
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
