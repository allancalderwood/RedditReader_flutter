import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/utils/timestampHelper.dart';

void postFactory(var jsonData, List<Post> posts){
  for(var postData in jsonData['data']['children']){
    double t = postData['data']['created_utc'];
    String time = readTimestamp(t.toInt());
    var p = postData['data'];
    Post post;
    if(!(p.containsKey('preview'))){
      post = new Post(p['name'],p['author_fullname'], p['author'],
          p['url'], p['thumbnail'],
          p['title'], p['selftext'], p['subreddit'],
          p['score'], p['num_comments'], time, p['permalink']);
    }else{
      post = new Post.withImage(p['name'],p['author_fullname'], p['author'],
          p['url'], p['thumbnail'], p['preview']['images'][0]['source']['height'], p['preview']['images'][0]['source']['width'],
          p['title'], p['selftext'], p['subreddit'],
          p['score'], p['num_comments'], time, p['permalink']);
    }
    posts.add(post);
  }
}