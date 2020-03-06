import 'package:flutter/material.dart';
import 'package:redditreader_flutter/screens/homePage.dart';
import 'package:redditreader_flutter/styles/theme.dart';

class RedditReaderAppBar extends StatefulWidget implements PreferredSizeWidget {
  RedditReaderAppBar({Key key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _RedditReaderAppBarState createState() => _RedditReaderAppBarState();
}

class _RedditReaderAppBarState extends State<RedditReaderAppBar>{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: currentTheme.backgroundColor.withOpacity(0.1),
      leading: IconButton(
        icon: Icon(Icons.menu, color: currentTheme.textTheme.headline1.color,),
        color: currentTheme.textTheme.headline1.color,
        iconSize: 50.0,
        onPressed: (){ Scaffold.of(context).openDrawer();}
      ),
      actions: <Widget>[
        new IconButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage())
            );
          },
          icon: Image.asset('assets/images/logo.png'),
        )
      ],
    );
  }
}
