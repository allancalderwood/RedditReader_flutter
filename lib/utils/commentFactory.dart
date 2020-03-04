import 'package:redditreader_flutter/models/comment.dart';
import 'package:redditreader_flutter/utils/timestampHelper.dart';

void commentFactory(var jsonData, List<Comment> comments){
  for(var commentData in jsonData[1]['data']['children']){
    print('RR: TEST1');
    String id = commentData['data']['id'];
    print('RR: TEST2');
    double t = commentData['data']['created_utc'];
    String time;
    if(t!=null){
      time = readTimestamp(t.toInt());
      String content = commentData['data']['body'];
      String author = commentData['data']['author'];
      int score = commentData['data']['score'];
      print('RR: TEST5');
      Comment comment = new Comment(id, author, content, score, time);

      comments.add(comment);
    }
  }
}