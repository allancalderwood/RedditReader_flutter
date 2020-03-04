import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redditreader_flutter/models/userOther.dart';
import 'package:redditreader_flutter/screens/login.dart';
import 'package:redditreader_flutter/screens/myProfile.dart';
import 'package:redditreader_flutter/screens/mySaved.dart';
import 'package:redditreader_flutter/screens/mySubreddits.dart';
import 'package:redditreader_flutter/utils/slides.dart';
import '../main.dart';
import '../styles/theme.dart';
import '../models/user.dart';

class RedditReaderDrawer extends StatefulWidget {

  @override
  _RedditReaderDrawer createState() => _RedditReaderDrawer();
}

class _RedditReaderDrawer extends State<RedditReaderDrawer> {

  @override
  void initState() {
    super.initState();
  }

  void logOut() {

    User.logOut();
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage())
    );
  }

  void changeTheme(){
    setState(() {
      if(darkTheme){
        darkTheme=false;
        currentTheme = buildLightTheme();
      }else{
        darkTheme=true;
        currentTheme = buildDefaultTheme();
      }
      AppBuilder.of(context).rebuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: currentTheme.primaryColor,
              ),
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // start at end/bottom of column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            User.profileURL,
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    )
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  color: new Color.fromRGBO(0, 0, 0, 0.5),
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${User.username}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: currentTheme.textTheme.headline1.color)),
                      Text('${User.karma} karma', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,color: currentTheme.textTheme.headline1.color)),
                      Text('${User.accountAge} ${User.accountAgePostfix}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13,color: currentTheme.textTheme.headline1.color)),
                    ],
                  )
                )
              ],
            )
          ),
          ListTile(
            onTap: (){
              Route route = SlideLeft(builder: (context) => MyProfile(profile: new UserOther(User.username, User.profileURL, User.karma, User.accountAge, User.accountAgePostfix), current: true,));
              Navigator.push(context, route);
            },
            title: Text('View my profile'),
          ),
          ListTile(
            onTap: (){
              Route route = SlideLeft(builder: (context) => MySubreddits());
              Navigator.push(context, route);
            },
            title: Text('My Subreddits'),
          ),
          ListTile(
            onTap: (){
              Route route = SlideLeft(builder: (context) => MySaved());
              Navigator.push(context, route);
            },
            title: Text('My Saved posts'),
          ),
          Expanded(
            child: new Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                        //padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        onPressed: logOut,
                        child: Text('Log Out', style: TextStyle(color: Colors.redAccent,))
                    ),
                    FlatButton(
                        color: currentTheme.splashColor,
                        //padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        onPressed: changeTheme,
                        child: Text('Change Theme')
                    ),
                  ],
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}
