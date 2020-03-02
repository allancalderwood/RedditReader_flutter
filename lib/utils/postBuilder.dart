import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/styles/theme.dart';

Widget futurePostBuilder(Future<List<Post>> future){
  return FutureBuilder<List<Post>>(
    future: future,
    builder: (context, snapshot){
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
        return Container(
            child: Center(
              child: CircularProgressIndicator(backgroundColor: currentTheme.primaryColor,),
            )
        );
        default:
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}', style:currentTheme.textTheme.headline2,);
          else
            return Container(
              height: 650,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return postWidget(snapshot.data[index]);
                },
              ),
            );
      }
    },
  );
}

Widget postWidget(Post p){
  return Container(
    margin: EdgeInsets.all(5.00),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.00))),
      child: InkWell(
        onTap: (){},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.00),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 280,
                    child: Text('${p.title}', maxLines: 3, overflow: TextOverflow.ellipsis,style: currentTheme.textTheme.headline4)
                  ),
                  FlatButton(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    onPressed: (){},
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                    ),
                    color: currentTheme.accentColor,
                    child: Text('r/${p.subreddit}', style: currentTheme.textTheme.headline5),
                  ),
                ],
              ),
            ),
            postImage(p),
            Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('${p.score}', style: currentTheme.textTheme.headline4),
                              Text('pts   ', style: TextStyle(fontSize: 15.0, color: currentTheme.splashColor)),
                              Text('${p.score}', style: currentTheme.textTheme.headline4),
                              Text(' comments', style: TextStyle(fontSize: 15.0, color: currentTheme.splashColor)),
                            ],
                          ),
                          Text('${p.time}', style: currentTheme.textTheme.headline4),
                          FlatButton(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            onPressed: (){},
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50.0),
                            ),
                            color: currentTheme.accentColor,
                            child: Text('${p.authorName}', style: currentTheme.textTheme.headline5),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              //Upvote
                            },
                            child: Icon(Icons.arrow_upward, size: 35, color: currentTheme.splashColor),
                          ),
                          GestureDetector(
                            onTap: (){
                              // Downvote
                            },
                            child: Icon(Icons.arrow_downward, size: 35, color: currentTheme.splashColor),
                          ),
                          GestureDetector(
                            onTap: (){
                              // Save
                            },
                            child: Icon(Icons.star_border, size: 35, color: currentTheme.splashColor),
                          ),
                          GestureDetector(
                            onTap: (){
                              // Extras
                            },
                            child: Icon(Icons.clear_all, size: 35, color: currentTheme.splashColor),
                          )
                        ],
                      ),
                    ],
                  )
                ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget postImage(Post p){
  if(p.imageURL!="self" ){
    return ClipRRect(
        child: FadeInImage(
          image: NetworkImage(p.imageURL),
          placeholder: AssetImage("assets/images/imagePlaceholderNSFW.png"),
          height: 250,
          fit: BoxFit.fill,
        )
    );
  } else return Padding(
    padding: EdgeInsets.all(15.00),
    child: Container(
      child: Text('${p.selftext}', maxLines:8, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13.0, color: currentTheme.splashColor)),
    ),
  );
}