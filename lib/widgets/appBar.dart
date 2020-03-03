import 'package:flutter/material.dart';
import 'file:///C:/Users/allan/AndroidStudioProjects/redditreader_flutter/lib/styles/theme.dart';
import 'package:redditreader_flutter/screens/homePage.dart';

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
      backgroundColor: Color(0x00000000),
      leading: IconButton(
        icon: Icon(Icons.menu),
        iconSize: 50.0,
        color: currentTheme.iconTheme.color,
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
