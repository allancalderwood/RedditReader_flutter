import 'package:flutter/material.dart';
import 'package:redditreader_flutter/styles/inputDecoration.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/widgets/drawer.dart';
import '../styles/theme.dart'; // import theme of app
import '../widgets/appBar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool homepage=true;
  bool popular=false;
  TextStyle homeText = currentTheme.textTheme.headline1;
  TextStyle popularText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);

  @override
  void initState() {
  }

  void _loadHome() {  // TODO
    setState(() {
    });
  }

  void homeClick(){
    if(!homepage){
      homepage=true;
      popular=false;
      setState(() {
        homeText = currentTheme.textTheme.headline1;
        popularText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
      });
    }
  }

  void popularClick(){
    if(!popular){
      popular=true;
      homepage=false;
      setState(() {
        popularText = currentTheme.textTheme.headline1;
        homeText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
      });
    }
  }

  void search(){

  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: RedditReaderAppBar(),
        drawer: RedditReaderDrawer(),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FlatButton(
                            //padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            onPressed: homeClick,
                            child: Text('Homepage', style: homeText)
                        ),
                        FlatButton(
                            //padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            onPressed: popularClick,
                            child:
                              Text('Popular', style: popularText),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20.00, 0, 15.00),
                      child: TextField(
                        decoration: buildInputDecoration("Search...",true,Icon(Icons.search)),
                      ),
                    )
                ])
        ),
        )
    );
  }
}
