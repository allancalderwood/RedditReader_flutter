class Post {
  String id;
  String subreddit;
  String title;
  String selftext;
  int score;
  String authorName;
  String imageURL;
  String time;
  int numComments;

  Post(this.id,this.authorName, this.imageURL, this.title, this.selftext, this.subreddit, this.score, this.numComments, this.time);
}