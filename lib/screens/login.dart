import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redditreader_flutter/models/user.dart';
import 'package:redditreader_flutter/screens/homePage.dart';
import 'package:redditreader_flutter/screens/register.dart'; // import register page
import '../styles/theme.dart'; // import theme of app
import '../utils/slides.dart'; // import slide animations
import 'authWebView.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState(){
    final storage = new FlutterSecureStorage();
    storage.read(key: 'accessToken').then((value) => skipLogin(value));
  }

  void skipLogin(String token){
    if(!(token==null)){
      User.retrieveUser();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage())
      );
    }
  }

  void _attemptLogin() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthWebView())
        );
    setState(() {
    });

  }

  Text _checkMessages(){
    final Map arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      return arguments['message'];
    }else return Text("");
  }

  // content of the screen
  @override
  Widget build(BuildContext context) {

     return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(50),
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/images/logo.png", width: 200,),
                    RichText(
                        text: TextSpan(
                        style: currentTheme.textTheme.headline2,
                        // set the default style for the children TextSpans
                        children: [
                          TextSpan(
                            text: 'Reddit ',
                              style: TextStyle(
                                  color: currentTheme.primaryColor
                              )
                          ),
                          TextSpan(
                              text: 'Reader'
                          ),
                        ]
                    )
                  ),
                    SizedBox(height: 100),
                    FlatButton(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        onPressed: _attemptLogin,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                        ),
                        color: currentTheme.primaryColor,
                        child: const Text('Login')
                    ),
                    SizedBox(height: 30),
                    Text("Don't have an account?", style: currentTheme.textTheme.bodyText1),
                    FlatButton(
                        onPressed: (){
                          Route route = SlideRight(builder: (context) => RegisterPage());
                          Navigator.push(context, route);
                        },
                        padding: EdgeInsets.all(0),
                        child: Text('Click here', style: TextStyle(fontSize: 14.0, color: currentTheme.primaryColor))
                    ),
                    SizedBox(height: 50),
                    _checkMessages(),
                  ],
                ))
        )
    );
  }
}
