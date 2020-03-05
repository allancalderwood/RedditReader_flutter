class Comment {
  String author;
  String id;
  String content;
  int score;
  String time;
  List<Comment> replies;
  String url;

  Comment(this.id, this.author, this.content, this.score, this.time, this.replies, String url){
    this.url = 'www.reddit.com'+url;
  }
}