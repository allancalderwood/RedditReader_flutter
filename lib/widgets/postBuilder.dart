import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/subreddit.dart';
import 'package:redditreader_flutter/models/userOther.dart';
import 'package:redditreader_flutter/screens/myProfile.dart';
import 'package:redditreader_flutter/screens/postPage.dart';
import 'package:redditreader_flutter/screens/postReply.dart';
import 'package:redditreader_flutter/screens/subredditPage.dart';
import 'package:redditreader_flutter/screens/viewImage.dart';
import 'package:redditreader_flutter/styles/theme.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:share/share.dart';

Widget futurePostBuilder(Future<List<Post>> future){
  final scrollController = ScrollController();
  scrollController.addListener(() {
    if(scrollController.position.maxScrollExtent == scrollController.offset){
      // TODO load more posts
    }
  });

  return FutureBuilder<List<Post>>(
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
            return Text('Unable to load posts.', style:currentTheme.textTheme.headline3,);
            //return new Text('Error: ${snapshot.error}', style:currentTheme.textTheme.headline2,);
          else if (snapshot.data==null || snapshot.data.isEmpty){
            return new Padding(
              padding: EdgeInsets.all(20),
              child: Text('No Posts found.', style:currentTheme.textTheme.headline3,),
            );
          }
          else{
            return Container(
              height: 950,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return postWidget(post: snapshot.data[index]);
                  },
                ),
              )
            );
          }
      }
    },
  );
}

Widget futurePostBuilderExp(Future<List<Post>> future){
  final scrollController = ScrollController();
  scrollController.addListener(() {
    if(scrollController.position.maxScrollExtent == scrollController.offset){
      // TODO load more posts
    }
  });

  return FutureBuilder<List<Post>>(
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
            return Text('Unable to load posts.', style:currentTheme.textTheme.headline3,);
          //return new Text('Error: ${snapshot.error}', style:currentTheme.textTheme.headline2,);
          else if (snapshot.data==null || snapshot.data.isEmpty){
            return new Padding(
              padding: EdgeInsets.all(20),
              child: Text('No Posts found.', style:currentTheme.textTheme.headline3,),
            );
          }
          else{
            return Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index){
                      return postWidget(post: snapshot.data[index]);
                    },
                  ),
                )
            );
          }
      }
    },
  );
}

class postWidget extends StatefulWidget{
  postWidget({Key key, this.post}) : super(key: key);
  final Post post;

  @override
  _postWidgetState createState() => _postWidgetState();
}

class _postWidgetState extends State<postWidget> {
  bool liked;
  bool upvoted;
  bool downvoted;
  final scrollController = ScrollController();

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

  void goToSubreddit(Post p){
    http.get(Uri.encodeFull(callBaseURL+'/r/${widget.post.subreddit}/about.json'), headers: getHeader()).then((response) => _loadSubreddit(response));
  }

  void goToUser(Post p)async{
    http.Response response = await http.get(Uri.encodeFull(callBaseURL+'/user/${p.authorName}/about.json'), headers: getHeader());
    var jsonData = json.decode(response.body);
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

  void loadPost(Post post){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostPage(post: post ))
    );
  }

  void reply(Post post) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostReply(post: post))
    );
  }


  void showPostOptions(Post post){
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('What do you wish to do with this post?', style: currentTheme.textTheme.bodyText1,),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Comment'),
              onPressed: () {
                reply(post);
              },
            ),
            new FlatButton(
              child: new Text('Share'),
              onPressed: () {
                String text = '${post.url}';
                Share.share(
                  text,
                  subject: 'Check out this Reddit Post',
                );
              },
            ),
            new FlatButton(
              child: new Text('Report'),
              onPressed: () {
                // TODO report
              },
            ),
          ],
        );
      },
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
          onTap: (){loadPost(widget.post);},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.00),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            FlatButton(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              onPressed: (){goToSubreddit(widget.post);},
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0),
                              ),
                              color: currentTheme.accentColor,
                              child: Text('r/${widget.post.subreddit}', style: currentTheme.textTheme.headline5),
                            ),
                            (widget.post.numAwards>0)? Row(
                              children: <Widget>[
                                SizedBox(width: 10,),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.orangeAccent.withOpacity(0.9),
                                    ),
                                    padding: EdgeInsets.fromLTRB(0, 0,0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.all(7),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.stars, size: 20, color: Colors.white,),
                                          SizedBox(width:5),
                                          Text('${widget.post.numAwards}', style: currentTheme.textTheme.headline4),
                                        ],
                                      ),
                                    )
                                )
                              ],
                            ):
                            SizedBox()
                          ],
                        ),
                        SizedBox(width: 10,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: currentTheme.accentColor,
                          ),
                          padding: EdgeInsets.fromLTRB(0, 0,0, 0),
                          child: Padding(
                            padding: EdgeInsets.all(7),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.access_alarm, size: 20,),
                                SizedBox(width:5),
                                Text('${widget.post.time}', style: currentTheme.textTheme.headline4),
                              ],
                            ),
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                        width: 400,
                        child: Text('${widget.post.title}', maxLines: 3, overflow: TextOverflow.ellipsis,style: currentTheme.textTheme.headline4)
                    ),
                  ],
                ),
              ),
              postImage(context, widget.post),
              Container(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('${widget.post.score}', style: currentTheme.textTheme.headline4),
                                Text(' pts   ', style: TextStyle(fontSize: 15.0, color: currentTheme.splashColor)),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text('${widget.post.numComments}', style: currentTheme.textTheme.headline4),
                                Text(' comments', style: TextStyle(fontSize: 15.0, color: currentTheme.splashColor)),
                              ],
                            ),
                            FlatButton(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              onPressed: (){goToUser(widget.post);},
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0),
                              ),
                              color: currentTheme.accentColor,
                              child: Text('${widget.post.authorName}', style: currentTheme.textTheme.headline5),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child:InkWell(
                                onTap: (){
                                  setState(() {
                                    if(upvoted){
                                      upvoted = false;
                                      widget.post.score--;
                                      vote(widget.post.id, 0);
                                    }else{
                                      upvoted = true;
                                      downvoted = false;
                                      widget.post.score++;
                                      vote(widget.post.id, 1);
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
                                      widget.post.score++;
                                      downvoted = false;
                                      vote(widget.post.id, 0);
                                    }else{
                                      downvoted = true;
                                      upvoted = false;
                                      widget.post.score--;
                                      vote(widget.post.id, -1);
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
                                      unsave(widget.post.id);
                                    }else{
                                      liked = true;
                                      save(widget.post.id, "None");
                                    }
                                  });
                                },
                                child: liked ? Icon(Icons.star, size: 35, color: Color((0xffD5AE3F))) : Icon(Icons.star_border, size: 35, color: currentTheme.splashColor),
                              ),
                            ),
                            Container(
                              child: InkWell(
                                onTap: (){
                                   showPostOptions(widget.post);
                                },
                                child: Icon(Icons.clear_all, size: 35, color: currentTheme.splashColor),
                              ),
                            )
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
    );
  }
}


Widget postImage(BuildContext context, Post p){
  if(p.imageURLPreview!="self" ){
    if(p.imageURLPreview!="nsfw"){
      return InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImagePage(post: p))
          );
        },
        child: ClipRRect(
            child: FadeInImage(
              image: NetworkImage(p.imageURL),
              placeholder: NetworkImage(p.imageURLPreview),
              height: imgHeight(p.imageHeight),
              width: imgWidth(p.imageWidth),
              fit: BoxFit.fill,
            )
        ),
      );
    }else{
      return ClipRRect(
          child: FadeInImage(
            image: AssetImage("assets/images/imagePlaceholderNSFW.png"),
            placeholder: AssetImage("assets/images/imagePlaceholderNSFW.png"),
            height: 250,
            fit: BoxFit.fill,
          )
      );
    }
  } else return Padding(
    padding: EdgeInsets.all(15.00),
    child: Container(
      child: Text('${p.selftext}', maxLines:8, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13.0, color: currentTheme.splashColor)),
    ),
  );
}

double imgHeight(int height){
  if (height==null){return 10.0;}
  if(height>2000){
    return height.toDouble()/8;
  }
  else if(height>1000 && height<=2000){
    return height.toDouble()/4;
  }else if(height<=1000 && height>600){
    return height.toDouble()/3;
  }else if(height<=600 && height>400){
    return height.toDouble()/2;
  }else return height.toDouble();

}

double imgWidth(int width){
  if (width==null){return 10.0;}
  if(width>2000){
    return width.toDouble()/8;
  }
  else if(width>1000 && width<=2000){
    return width.toDouble()/4;
  }else if(width<=1000 && width>600){
    return width.toDouble()/3;
  }else if(width<=600 && width>400){
    return width.toDouble()/2;
  }else return width.toDouble();
}