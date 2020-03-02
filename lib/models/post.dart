class Post {
  String subreddit;
  String title;
  String selftext;
  int score;
  String authorName;
  String imageURL;
  String time;

  Post(this.authorName, this.imageURL, this.title, this.selftext, this.subreddit, this.score, this.time);
}