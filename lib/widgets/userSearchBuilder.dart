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

Widget futureUserSearchBuilder(Future<List<UserOther>> future){
  return FutureBuilder<List<UserOther>>(
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
          else if (snapshot.data==null || snapshot.data.isEmpty){
            return new Padding(
              padding: EdgeInsets.all(20),
              child: Text('No Users found.', style:currentTheme.textTheme.headline3,),
            );
          }
          else{
            return Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return userWidget(user: snapshot.data[index]);
                  },
                ),
              )
            );
          }
      }
    },
  );
}

class userWidget extends StatefulWidget{
  userWidget({Key key, this.user}) : super(key: key);
  final UserOther user;

  @override
  _userWidgetState createState() => _userWidgetState();
}

class _userWidgetState extends State<userWidget> {

  @override
  void initState() {
    super.initState();
  }

  void goToUser(){
    UserOther profile = widget.user;
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyProfile(profile: profile, current: false,))
    );
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
          onTap: (){goToUser();},
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
                                  imageUrl: (widget.user.profileURL==null) ? 'https: pbs.twimg.com/profile_images/1197561676393926656/KUZlGyLX_400x400.jpg' : widget.user.profileURL,
                                  placeholder: (context, url) => new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => new Icon(Icons.supervised_user_circle),
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text('u/${widget.user.username}', style: currentTheme.textTheme.headline2),
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