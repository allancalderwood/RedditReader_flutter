class Post {
  String id;
  String subreddit;
  String title;
  String selftext;
  int score;
  String authorName;
  String authorID;
  String imageURL;
  int imageWidth;
  int imageHeight;
  String imageURLPreview;
  String time;
  int numComments;
  String url;

  Post(this.id,this.authorID,this.authorName,
      this.imageURL, this.imageURLPreview,
      this.title, this.selftext, this.subreddit,
      this.score, this.numComments, this.time, String url){
    this.url = 'www.reddit.com'+url;
  }

  Post.withImage(this.id,this.authorID,this.authorName,
      this.imageURL, this.imageURLPreview, this.imageHeight, this.imageWidth,
      this.title, this.selftext, this.subreddit,
      this.score, this.numComments, this.time, String url){
    this.url = 'www.reddit.com'+url;
  }
}