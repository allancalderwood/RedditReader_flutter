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
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/.json'), headers: headers);
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadHome());
    }else{
      postFactory(jsonData, posts);
      return posts;
    }
  }

  Future<List<Post>> _loadPopular() async{  // TODO
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/best'), headers: headers);
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadHome());
    }else{
      postFactory(jsonData, posts);
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
