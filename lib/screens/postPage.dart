import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/comment.dart';
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/styles/theme.dart';
import 'package:redditreader_flutter/utils/commentFactory.dart';
import 'package:redditreader_flutter/widgets/commentBuilder.dart';
import 'package:redditreader_flutter/widgets/expandedPost.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';

class PostPage extends StatefulWidget {
  PostPage({Key key, this.post}) : super(key: key);
  final Post post;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Widget currentPage;

  @override
  initState(){
    currentPage = futureCommentBuilder(_loadComments());
    super.initState();
  }

  Future<List<Comment>> _loadComments()async{
    String id = widget.post.id.substring(3);
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/r/${widget.post.subreddit}/comments/$id.json'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Comment> comments = [];
    commentFactory(jsonData, comments);
    return comments;
  }

  Future<void> _refresh(){
    Completer<Null> c = new Completer<Null>();
    setState((){
      currentPage = futureCommentBuilder(_loadComments());
    });
    c.complete();
    return c.future;
  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(0,20,0,20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ExpandedPostWidget(post: widget.post),
                  new RefreshIndicator(
                      color: currentTheme.primaryColor,
                      onRefresh: _refresh,
                      child: currentPage
                  ),
                ],
              ),
            )
        )
    );
  }
}
