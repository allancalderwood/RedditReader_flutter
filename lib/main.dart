import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redditreader_flutter/screens/login.dart';
import 'package:redditreader_flutter/screens/register.dart';

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
      home: needAuthorized(),
    );
  }
}

Widget needAuthorized(){
  storage.read(key: 'accessToken').then((value) => print("$value"));
  
  bool _authorized = false;

  if(_authorized==true){
    //TODO take to login
    return HomePage(title: 'HomePage');
  }
  else{
    return LoginPage(title: 'Login or Register');;
  }
}