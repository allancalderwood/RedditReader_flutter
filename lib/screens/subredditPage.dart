import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/subreddit.dart';
import 'package:redditreader_flutter/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redditreader_flutter/styles/inputDecoration.dart';
import 'package:redditreader_flutter/utils/postFactory.dart';
import 'package:redditreader_flutter/widgets/postBuilder.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/utils/timestampHelper.dart';
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

  @override
  initState(){
    mustCallSuper;
  }

  Future<List<Post>> _loadSubreddit()async{
    Map<String, String> _headers = {'User-Agent':clientID,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Bearer ${User.token}'};
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/r/${widget.sub.name}.json'), headers: _headers);
    var jsonData = json.decode(data.body);
    List<Post> posts = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadSubreddit());
    }else{
      postFactory(jsonData, posts);
      return posts;
    }
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
          child: Center(
              child: Stack(
                children: <Widget>[
                  new CachedNetworkImage(
                    height: 300,
                    imageUrl: widget.sub.headerUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Container(height: 300, decoration: BoxDecoration(color: currentTheme.primaryColor),),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Color(0xFF0E3311).withOpacity(0.2)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20,100,20,20),
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
                                'R/${widget.sub.name}', style: currentTheme.textTheme.headline1,
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
                          futurePostBuilder(_loadSubreddit())
                        ]),
                  )
                ],
              )
          ),
        )
    );
  }
}
