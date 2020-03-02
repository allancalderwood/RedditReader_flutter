import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/user.dart';
import 'package:redditreader_flutter/styles/inputDecoration.dart';
import 'package:redditreader_flutter/utils/postBuilder.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/utils/timestampHelper.dart';
import 'package:redditreader_flutter/widgets/drawer.dart';
import '../styles/theme.dart'; // import theme of app
import '../widgets/appBar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool homepage=true;
  bool popular=false;
  TextStyle homeText = currentTheme.textTheme.headline1;
  TextStyle popularText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
  Widget currentPage;

  @override
  initState(){
    currentPage = futurePostBuilder(_loadHome());
    mustCallSuper;
  }

  Future<List<Post>> _loadHome()async{
    Map<String, String> _headers = {'User-Agent':clientID,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Bearer ${User.token}'};
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/.json'), headers: _headers);
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    print("RR: $jsonData");
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadHome());
    }else{
      for(var p in jsonData['data']['children']){
        double t = p['data']['created_utc'];
        String time = readTimestamp(t.toInt());
        Post post = new Post(p['data']['name'],p['data']['author_fullname'], p['data']['thumbnail'], p['data']['title'],p['data']['selftext'], p['data']['subreddit'], p['data']['score'],p['data']['num_comments'], time);
        posts.add(post);
      }
      return posts;
    }
  }

  Future<List<Post>> _loadPopular() async{  // TODO
    Map<String, String> _headers = {'User-Agent':clientID,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Bearer ${User.token}'};
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/best'), headers: _headers);
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadHome());
    }else{
      for(var p in jsonData['data']['children']){
        double t = p['data']['created_utc'];
        String time = readTimestamp(t.toInt());
        Post post = new Post(p['data']['name'],p['data']['author_fullname'], p['data']['thumbnail'], p['data']['title'],p['data']['selftext'], p['data']['subreddit'], p['data']['score'],p['data']['num_comments'], time);
        posts.add(post);
      }
      return posts;
    }
  }

  void homeClick(){
    if(!homepage){
      homepage=true;
      popular=false;
      setState(() {
        homeText = currentTheme.textTheme.headline1;
        popularText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
        currentPage = futurePostBuilder(_loadHome());
      });
    }
  }

  void popularClick(){
    if(!popular){
      popular=true;
      homepage=false;
      setState(() {
        popularText = currentTheme.textTheme.headline1;
        homeText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
        currentPage = futurePostBuilder(_loadPopular());
      });
    }
  }

  void search(){
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FlatButton(
                            //padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            onPressed: homeClick,
                            child: Text('Homepage', style: homeText)
                        ),
                        FlatButton(
                            //padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            onPressed: popularClick,
                            child:
                              Text('Popular', style: popularText),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20.00, 0, 15.00),
                      child: TextField(
                        maxLines: 1,
                        decoration: buildInputDecoration("Search...",true,Icon(Icons.search)),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: currentPage,
                    ),
                ])
        ),
        )
    );
  }
}
