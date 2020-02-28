import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redditreader_flutter/screens/login.dart';
import 'package:redditreader_flutter/screens/register.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';

import 'styles/theme.dart'; // import theme of app
import 'screens/homePage.dart'; // import the login page

void main() => runApp(RedditReader());

final storage = new FlutterSecureStorage();

class RedditReader extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RedditReader',
      theme: currentTheme,
      routes: <String, WidgetBuilder>{
        "/Login": (BuildContext context)=> new LoginPage(),
        "/Register": (BuildContext context)=> new RegisterPage(),
        "/Homepage": (BuildContext context)=> new RegisterPage()
      },
      home: _needAuthorized(),
    );
  }
}

Widget _needAuthorized(){
  //if(storage.read(key: 'accessToken')==null){ // if not logged in already
    return LoginPage(title: 'Login or Register');
 // }else{
    //refreshToken();
    //return HomePage(title: 'HomePage');
  //}
}