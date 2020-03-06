class Comment {
  String author;
  String id;
  String content;
  int score;
  String time;
  List<Comment> replies;
  String url;
  String flair;
  int numAwards;

  Comment(this.id, this.author, this.content, this.score, this.time, this.replies, String url, String flair, this.numAwards){
    this.url = 'www.reddit.com'+url;
    this.flair = flair.replaceAll(':', '').replaceAll('_', ' ');
  }
}