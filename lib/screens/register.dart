import 'package:flutter/material.dart';
import 'package:redditreader_flutter/screens/login.dart';
import 'package:redditreader_flutter/styles/inputDecoration.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../styles/theme.dart'; // import theme of app
import '../utils/slides.dart'; // import slide animations

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  WebViewController _controller;

  void _attemptRegister() {  // TODO login functionality
    setState(() {
    });

  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://www.reddit.com/register/',
        onWebViewCreated: (WebViewController c){
          _controller = c;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Route route = SlideLeft(builder: (context) => LoginPage());
          Navigator.push(context, route);
        },
        child: Image.asset('assets/images/logo.png', width: 35),
        backgroundColor: currentTheme.accentColor,
      ),
    );
  }
}
