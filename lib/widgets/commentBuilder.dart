
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:redditreader_flutter/models/comment.dart';
import 'package:redditreader_flutter/models/userOther.dart';
import 'package:redditreader_flutter/screens/myProfile.dart';
import 'package:redditreader_flutter/styles/theme.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Widget futureCommentBuilder(Future<List<Comment>> future){
  return FutureBuilder<List<Comment>>(
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
              child: Text('No Comment found.', style:currentTheme.textTheme.headline3,),
            );
          }
          else{
            return Container(
              height: 800,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return commentWidget(comment: snapshot.data[index]);
                  },
                ),
              )
            );
          }
      }
    },
  );
}

class commentWidget extends StatefulWidget{
  commentWidget({Key key, this.comment}) : super(key: key);
  final Comment comment;

  @override
  _commentWidgettState createState() => _commentWidgettState();
}

class _commentWidgettState extends State<commentWidget> {
  bool liked = false;
  bool upvoted = false;
  bool downvoted = false;

  @override
  void initState() {
    super.initState();
  }

  void reply(Comment comment) {

  }

  void goToUser(Comment c)async{
    http.Response response = await http.get(Uri.encodeFull(callBaseURL+'/user/${c.author}/about.json'), headers: getHeader());
    var jsonData = json.decode(response.body);
    print('RR: $jsonData');
    var userData = jsonData['data'];
    var karma = ( (userData['link_karma']) + (userData['comment_karma']));
    int seconds = ( userData['created'] /10).floor();
    int daysSince = (seconds/86400).floor();
    var age;
    String message = 'days old';

    if(daysSince>30 && daysSince<365){
      daysSince =  (daysSince/30).floor();
      age = daysSince.floor().toInt();
      message =  'mnths old';
    }
    else if(daysSince>365){
      daysSince =  (daysSince/365).floor();
      age = daysSince.floor().toInt();
      message = 'yr old';
    }else{
      age = daysSince.floor().toInt();
    }
    var accountAge = age;
    var accountAgePostfix = message;

    UserOther profile = new UserOther(userData['name'], userData['icon_img'].toString(), karma, accountAge, accountAgePostfix);
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
          onTap: (){reply(widget.comment);},
          child: Padding(
            padding: EdgeInsets.all(10.00),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      onPressed: (){goToUser(widget.comment);},
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                      ),
                      color: currentTheme.accentColor,
                      child: Text('${widget.comment.author}', style: currentTheme.textTheme.headline5),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: currentTheme.accentColor,
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0,0, 0),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.access_alarm, size: 15,),
                              SizedBox(width:5),
                              Text('${widget.comment.time}', style: currentTheme.textTheme.headline4),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text(widget.comment.content, style: currentTheme.textTheme.bodyText1,),
                SizedBox(height: 20,),
                Container(
                  child: Padding(
                      padding: EdgeInsets.all(1),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text('${widget.comment.score}', style: currentTheme.textTheme.headline4),
                                      Text(' pts   ', style: TextStyle(fontSize: 15.0, color: currentTheme.splashColor)),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                child:InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(upvoted){
                                        upvoted = false;
                                        widget.comment.score--;
                                        vote(widget.comment.id, 0);
                                      }else{
                                        upvoted = true;
                                        downvoted = false;
                                        widget.comment.score++;
                                        vote(widget.comment.id, 1);
                                      }
                                    });
                                  },
                                  child: upvoted ? Icon(Icons.arrow_upward, size: 35, color: Color(0xff31B3A4)) : Icon(Icons.arrow_upward, size: 35, color: currentTheme.splashColor),
                                ),
                              ),
                              Container(
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(downvoted){
                                        widget.comment.score++;
                                        downvoted = false;
                                        vote(widget.comment.id, 0);
                                      }else{
                                        downvoted = true;
                                        upvoted = false;
                                        widget.comment.score--;
                                        vote(widget.comment.id, -1);
                                      }
                                    });
                                  },
                                  child: downvoted ? Icon(Icons.arrow_downward, size: 35, color: Color((0xffD5433F))) : Icon(Icons.arrow_downward, size: 35, color: currentTheme.splashColor),
                                ),
                              ),
                              Container(
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(liked){
                                        liked = false;
                                        unsave(widget.comment.id);
                                      }else{
                                        liked = true;
                                        save(widget.comment.id, "None");
                                      }
                                    });
                                  },
                                  child: liked ? Icon(Icons.star, size: 35, color: Color((0xffD5AE3F))) : Icon(Icons.star_border, size: 35, color: currentTheme.splashColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}