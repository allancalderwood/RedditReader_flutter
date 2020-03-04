import 'dart:async';
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
  Widget currentPage;

  @override
  initState(){
    currentPage = futurePostBuilder(_loadSubPosts());
    super.initState();
  }


  Future<List<Post>> _loadSubPosts()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/r/${widget.sub}/search.json?limit=100&q=${widget.search}&type=link&restrict_sr=on'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadSubPosts());
    }else{
      postFactory(jsonData, posts);
      return posts;
    }
  }

  Future<void> _refresh(){
    Completer<Null> c = new Completer<Null>();
    setState((){
        currentPage = futurePostBuilder(_loadSubPosts());
    });
    c.complete();
    return c.future;
  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: RedditReaderAppBar(),
        drawer: RedditReaderDrawer(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(0,20,0,20),
            child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text('Results', style: currentTheme.textTheme.headline1,),
                    SizedBox(height: 40),
                    RefreshIndicator(
                      color: currentTheme.primaryColor,
                      onRefresh: _refresh,
                      child: currentPage,
                    ),
                  ],
              )
        )
    );
  }
}
