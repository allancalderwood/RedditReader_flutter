import 'package:redditreader_flutter/models/comment.dart';
import 'package:redditreader_flutter/utils/timestampHelper.dart';

void commentFactory(var jsonData, List<Comment> comments){
  for(var commentData in jsonData[1]['data']['children']){
    String id = commentData['data']['id'];
    double t = commentData['data']['created_utc'];
    String time;
    if(t!=null){
      time = readTimestamp(t.toInt());
      String content = commentData['data']['body'];
      String author = commentData['data']['author'];
      String url = commentData['data']['permalink'];
      int score = commentData['data']['score'];
      List<Comment> replies = [];
      _replyFactory(commentData, replies);
      Comment comment = new Comment(id, author, content, score, time, replies, url);
      comments.add(comment);
    }
  }
}

void _replyFactory(var commentData, List<Comment> replies){
  if(!(commentData['data']['replies']=="")){
    for(var replyData in commentData['data']['replies']['data']['children']){
      String id = replyData['data']['id'];
      double t = replyData['data']['created_utc'];
      String time;
      if(t!=null){
        time = readTimestamp(t.toInt());
        String url = replyData['data']['permalink'];
        String content = replyData['data']['body'];
        String author = replyData['data']['author'];
        int score = replyData['data']['score'];
        List<Comment> rep2 = [];
        _replyFactory(replyData, rep2);
        Comment comment = new Comment(id, author, content, score, time, rep2, url);
        replies.add(comment);
      }
    }
  }
}