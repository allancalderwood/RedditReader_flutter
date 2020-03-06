import 'package:flutter/material.dart';
import 'package:redditreader_flutter/models/comment.dart';
import 'package:redditreader_flutter/styles/theme.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/widgets/commentBuilder.dart';

class CreateComment extends StatefulWidget {
  CreateComment({Key key, this.comment}) : super(key: key);
  final Comment comment;

  @override
  _CreateCommentState createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateComment> {
  String content='';

  @override
  initState(){
    super.initState();
  }

  void create(Comment comment){
    String id = ('t1_${comment.id}');
    commentCall(id, content);
    Navigator.of(context).pop();
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
                  Text('You are replying to this comment:', style: currentTheme.textTheme.headline1,),
                  SizedBox(height: 30,),
                  commentWidgetViewOnly(comment: widget.comment,),
                  SizedBox(height: 50,),
                  Card(
                    color: currentTheme.primaryColorDark,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        onSubmitted: (value){create(widget.comment);},
                        onChanged: (value){content=value;},
                        maxLines: 20,
                        decoration: InputDecoration.collapsed(hintText: "Enter your comment here."),
                      ),
                    )
                  ),
                  SizedBox(height: 30,),
                  FlatButton(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      onPressed: (){create(widget.comment);},
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
