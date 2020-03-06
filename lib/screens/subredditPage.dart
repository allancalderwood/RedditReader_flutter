import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/subreddit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redditreader_flutter/screens/searchSubredditPage.dart';
import 'package:redditreader_flutter/styles/inputDecoration.dart';
import 'package:redditreader_flutter/utils/postFactory.dart';
import 'package:redditreader_flutter/utils/subFactory.dart';
import 'package:redditreader_flutter/widgets/postBuilder.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/widgets/drawer.dart';
import '../styles/theme.dart'; // import theme of app
import '../widgets/appBar.dart';

class SubredditPage extends StatefulWidget {
  SubredditPage({Key key, this.sub}) : super(key: key);
  final Subreddit sub;

  @override
  _SubredditState createState() => _SubredditState();
}

class _SubredditState extends State<SubredditPage> {
  Widget currentPage;
  String selected;
  String subStatus = 'Subscribe';
  bool subbed = false;

  @override
  initState(){
    currentPage = futurePostBuilder(_loadSubreddit());
    selected = 'Hot';
    _loadSubs();
    super.initState();
  }

  Future<void> _loadSubs()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/subreddits/mine/subscriber.json?limit=1000'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Subreddit> subs = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadSubs());
    }else{
      subFactory(jsonData, subs);
      bool contains= false;
      for (Subreddit s in subs) {
        if (s.name == widget.sub.name){
          contains=true;
        }
      }
      setState(() {
        if(contains){
          subStatus = 'Subscribed';
          subbed = true;
        }
      });
    }
  }

  changeSelected(String value){
    setState(() {
      selected = value;
      if(selected=='Hot'){
        currentPage = futurePostBuilder(_loadSubreddit());
      }else if(selected=='New'){
        currentPage = futurePostBuilder(_loadSubredditNew());
      }else{
        currentPage = futurePostBuilder(_loadSubredditTop());
      }
    });
  }

  Future<void> _refresh(){
    Completer<Null> c = new Completer<Null>();
    setState((){
      if(selected=='Hot'){
        currentPage = futurePostBuilder(_loadSubreddit());
      }else if(selected=='New'){
        currentPage = futurePostBuilder(_loadSubredditNew());
      }else{
        currentPage = futurePostBuilder(_loadSubredditTop());
      }
    });
    c.complete();
    return c.future;
  }

  Future<List<Post>> _loadSubreddit()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/r/${widget.sub.name}.json?limit=200'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadSubreddit());
    }else{
      postFactory(jsonData, posts);
      return posts;
    }
  }

  Future<List<Post>> _loadSubredditNew()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/r/${widget.sub.name}/new/.json?limit=200'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadSubreddit());
    }else{
      postFactory(jsonData, posts);
      return posts;
    }
  }

  Future<List<Post>> _loadSubredditTop()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/r/${widget.sub.name}/top/.json?limit=200&t=all'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadSubreddit());
    }else{
      postFactory(jsonData, posts);
      return posts;
    }
  }

  void _search(String search)async{
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchSubredditPage(search: search, sub: widget.sub.name))
    );
  }


  // content of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: RedditReaderAppBar(),
        drawer: RedditReaderDrawer(),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0,0,0,0),
          child: SingleChildScrollView(child: Center(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      new CachedNetworkImage(
                        height: 300,
                        imageUrl: widget.sub.headerUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Container(height: 300, decoration: BoxDecoration(color: Colors.red),),
                      ),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                            color: currentTheme.backgroundColor.withOpacity(0.2)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20,100,20,0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(100.0),
                                      child: new CachedNetworkImage(
                                        height: 50,
                                        width: 50,
                                        imageUrl: widget.sub.iconUrl,
                                        placeholder: (context, url) => new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => new Icon(Icons.supervised_user_circle),
                                      )
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'R/${widget.sub.name}', style: (widget.sub.name.length<14)? currentTheme.textTheme.headline1: ((widget.sub.name.length<=24)? currentTheme.textTheme.headline2:currentTheme.textTheme.headline3),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20.00, 0, 25.00),
                                child: TextField(
                                  onSubmitted: (value){_search(value);},
                                  maxLines: 1,
                                  decoration: buildInputDecoration("Search...",true,Icon(Icons.search)),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.0),
                                        color: Colors.transparent,
                                      ),
                                      padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          DropdownButtonHideUnderline(
                                            child: new DropdownButton<String>(
                                              value: selected,
                                              items: <String>['Hot', 'Top', 'New'].map((String value) {
                                                return new DropdownMenuItem<String>(
                                                  value: value,
                                                  child: new Text(value, style: currentTheme.textTheme.bodyText1),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                changeSelected(value);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15.0),
                                                color: subbed? Colors.grey:currentTheme.primaryColor,
                                              ),
                                              child: FlatButton(
                                                onPressed: (){
                                                  setState(() {
                                                    if(subbed){
                                                      subbed = false;
                                                      subStatus = 'Subscribe';
                                                      subscribe(widget.sub.name, 'unsub');
                                                    }else{
                                                      subbed = true;
                                                      subStatus = 'Subscribed';
                                                      subscribe(widget.sub.name, 'sub');
                                                    }
                                                  });
                                                },
                                                child: Text(subStatus),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ]),
                      )
                    ],
                  ),
                  RefreshIndicator(
                    color: currentTheme.primaryColor,
                    onRefresh: _refresh,
                    child: currentPage,
                  )
                ],
              )
          ),)
        )
    );
  }
}
