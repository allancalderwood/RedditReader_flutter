import 'package:flutter/material.dart';
import 'file:///C:/Users/allan/AndroidStudioProjects/redditreader_flutter/lib/styles/theme.dart';

class RedditReaderDrawer extends Drawer {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                color: currentTheme.primaryColor,
                //image: DecorationImage( // TODO Add background image of user
                    //image: AssetImage("assets/images/logo.png"),
                   // fit: BoxFit.cover)
            ),
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // start at end/bottom of column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    child: Icon(
                      Icons.person, //TODO add user picture
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  color: new Color.fromRGBO(0, 0, 0, 0.5),
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Username'), //TODO Add username
                      Text('100karma'), //TODO add Karma score
                      Text('1yr reddit age'), //TODO add age
                    ],
                  )
                )
              ],
            )
          ),
          ListTile(
            title: Text('View my profile'),
          ),
          ListTile(
            title: Text('My Subreddits'),
          ),
          ListTile(
            title: Text('Saved posts'),
          ),
        ],
      ),
    );
  }
}
