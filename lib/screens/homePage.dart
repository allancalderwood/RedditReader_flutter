import 'package:flutter/material.dart';
import 'package:redditreader_flutter/main.dart';
import 'package:redditreader_flutter/widgets/drawer.dart';
import '../styles/theme.dart'; // import theme of app
import '../widgets/appBar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageeState createState() => _HomePageeState();
}

class _HomePageeState extends State<HomePage> {

  void _loadHome() {  // TODO
    setState(() {
    });

  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: RedditReaderAppBar(),
        drawer: RedditReaderDrawer(),
        body: Padding(
            padding: EdgeInsets.all(50),
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/images/logo.png", width: 200,),
                    Text('RedditReader', style: currentTheme.textTheme.headline2,),
                    SizedBox(height: 50),
                ])
        ),
        )
    );
  }
}
