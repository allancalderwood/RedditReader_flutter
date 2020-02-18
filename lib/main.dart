import 'package:flutter/material.dart';
import 'package:redditreader_flutter/screens/register.dart';

import 'styles/theme.dart'; // import theme of app
import 'screens/login.dart'; // import the login page

void main() => runApp(RedditReader());

class RedditReader extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RedditReader',
      theme: currentTheme,
      routes: <String, WidgetBuilder>{
        "/Register": (BuildContext context)=> new RegisterPage()
      },
      home: LoginPage(title: 'Login or Register'),
    );
  }
}
