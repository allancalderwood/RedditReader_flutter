import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:redditreader_flutter/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/subreddit.dart';
import 'package:redditreader_flutter/models/userOther.dart';
import 'package:redditreader_flutter/screens/myProfile.dart';
import 'package:redditreader_flutter/screens/subredditPage.dart';
import 'package:redditreader_flutter/styles/theme.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:share/share.dart';

Widget futureSubBuilder(Future<List<Subreddit>> future){
  return FutureBuilder<List<Subreddit>>(
    future: future,
    builder: (context, snapshot){
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
        return Container(
            child: Center(
              child: CircularProgressIndicator(backgroundColor: currentTheme.primaryColor,),
            )
        );
        default:
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}', style:currentTheme.textTheme.headline2,);
          else
            return Container(
              height: 620,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return subWidget(sub: snapshot.data[index]);
                },
              ),
            );
      }
    },
  );
}

class subWidget extends StatefulWidget{
  subWidget({Key key, this.sub}) : super(key: key);
  final Subreddit sub;

  @override
  _subWidgetState createState() => _subWidgetState();
}

class _subWidgetState extends State<subWidget> {
  bool liked;
  bool upvoted;
  bool downvoted;

  @override
  void initState() {
    liked = false;
    upvoted = false;
    downvoted = false;
    super.initState();
  }

  void _loadSubreddit(http.Response response){
    var jsonData = json.decode(response.body);
    String name = jsonData['data']['display_name'];
    String header = jsonData['data']['banner_background_image'];
    String icon = jsonData['data']['icon_img'];
    Subreddit sub = new Subreddit(name, icon, header);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SubredditPage(sub: sub))
    );
  }

  void goToSubreddit(){
    http.get(Uri.encodeFull(callBaseURL+'/r/${widget.sub.name}/about.json'), headers: getHeader()).then((response) => _loadSubreddit(response));
  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.00))),
        child: InkWell(
          onTap: (){goToSubreddit();},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.00),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: new CachedNetworkImage(
                                  height: 50,
                                  width: 50,
                                  imageUrl: (widget.sub.iconUrl==null) ? 'https: pbs.twimg.com/profile_images/1197561676393926656/KUZlGyLX_400x400.jpg' : widget.sub.iconUrl,
                                  placeholder: (context, url) => new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => new Icon(Icons.supervised_user_circle),
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text('r/${widget.sub.name}', style: currentTheme.textTheme.headline2),
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}