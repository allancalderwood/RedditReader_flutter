import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/user.dart';
import 'package:redditreader_flutter/styles/theme.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';

Widget futurePostBuilder(Future<List<Post>> future){
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
            return new Text('Error: ${snapshot.error}', style:currentTheme.textTheme.headline2,);
          else
            return Container(
              height: 650,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return postWidget(post: snapshot.data[index]);
                },
              ),
            );
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

  @override
  void initState() {
    liked = false;
    upvoted = false;
    downvoted = false;
    super.initState();
    print("RR: ${widget.post.id}");
  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.00),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.00))),
        child: InkWell(
          onTap: (){},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.00),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: 280,
                        child: Text('${widget.post.title}', maxLines: 3, overflow: TextOverflow.ellipsis,style: currentTheme.textTheme.headline4)
                    ),
                    FlatButton(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      onPressed: (){},
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                      ),
                      color: currentTheme.accentColor,
                      child: Text('r/${widget.post.subreddit}', style: currentTheme.textTheme.headline5),
                    ),
                  ],
                ),
              ),
              postImage(widget.post),
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
                                Text('pts   ', style: TextStyle(fontSize: 15.0, color: currentTheme.splashColor)),
                                Text('${widget.post.numComments}', style: currentTheme.textTheme.headline4),
                                Text(' comments', style: TextStyle(fontSize: 15.0, color: currentTheme.splashColor)),
                              ],
                            ),
                            Text('${widget.post.time}', style: currentTheme.textTheme.headline4),
                            FlatButton(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              onPressed: (){},
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
                                      save(widget.post.id, "Posts");
                                    }
                                  });
                                },
                                child: liked ? Icon(Icons.star, size: 35, color: Color((0xffD5AE3F))) : Icon(Icons.star_border, size: 35, color: currentTheme.splashColor),
                              ),
                            ),
                            Container(
                              child: InkWell(
                                onTap: (){
                                   AlertDialog(
                                    // TODO
                                  );
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


Widget postImage(Post p){
  if(p.imageURL!="self" ){
    if(p.imageURL!="nsfw"){
      return ClipRRect(
          child: FadeInImage(
            image: NetworkImage(p.imageURL),
            placeholder: AssetImage("assets/images/imagePlaceholderNSFW.png"),
            height: 250,
            fit: BoxFit.fill,
          )
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