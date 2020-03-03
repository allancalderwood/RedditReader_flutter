import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/models/subreddit.dart';
import 'package:redditreader_flutter/utils/timestampHelper.dart';

void subFactory(var jsonData, List<Subreddit> subs){
  for(var subData in jsonData['data']['children']){
    var s = subData['data'];
    Subreddit sub;
    sub = new Subreddit(s['display_name'],s['icon_img'], s['header_img']);
    subs.add(sub);
  }
}