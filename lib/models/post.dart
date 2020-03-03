class Post {
  String id;
  String subreddit;
  String title;
  String selftext;
  int score;
  String authorName;
  String imageURL;
  String imageURLPreview;
  String time;
  int numComments;
  String url;

  Post(this.id,this.authorName, this.imageURL, this.imageURLPreview, this.title, this.selftext, this.subreddit, this.score, this.numComments, this.time,String url){
    this.url = 'www.reddit.com'+url;
  }
}