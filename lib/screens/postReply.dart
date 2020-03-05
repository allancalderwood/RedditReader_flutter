import 'package:flutter/material.dart';
import 'package:redditreader_flutter/models/comment.dart';
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/styles/theme.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/widgets/commentBuilder.dart';
import 'package:redditreader_flutter/widgets/postBuilder.dart';

class PostReply extends StatefulWidget {
  PostReply({Key key, this.post}) : super(key: key);
  final Post post;

  @override
  _PostReplyState createState() => _PostReplyState();
}

class _PostReplyState extends State<PostReply> {
  String content='';

  @override
  initState(){
    super.initState();
  }

  void create(Post post){
    commentCall(post.id, content);
  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(20,80,20,20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('You are commenting on this Post:', style: currentTheme.textTheme.headline1,),
                  SizedBox(height: 30,),
                  postWidget(post: widget.post),
                  SizedBox(height: 50,),
                  Card(
                    color: currentTheme.primaryColorDark,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        onSubmitted: (value){create(widget.post);},
                        onChanged: (value){content=value;},
                        maxLines: 20,
                        decoration: InputDecoration.collapsed(hintText: "Enter your comment here."),
                      ),
                    )
                  ),
                  SizedBox(height: 30,),
                  FlatButton(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      onPressed: (){create(widget.post);},
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                      color: currentTheme.primaryColor,
                      child: const Text('Post')
                  ),
                ],
              ),
            )
        )
    );
  }
}
