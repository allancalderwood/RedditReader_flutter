import 'package:flutter/material.dart';
import 'package:redditreader_flutter/screens/register.dart';
import '../styles/theme.dart'; // import theme of app
import '../utils/slides.dart'; // import slide animations
import 'package:redditreader_flutter/styles/inputDecoration.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  String _username = "";
  String _password = "";

  void _attemptLogin() {  // TODO login functionality
    print(_username.toString());
    print(_password.toString());
    setState(() {
    });

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
                    Text('RedditReader', style: currentTheme.textTheme.headline2,),
                    SizedBox(height: 50),
                    new TextField(
                      style: currentTheme.textTheme.bodyText2,
                      decoration: buildInputDecoration("Username"),
                      enabled: true,
                      maxLength: 30,
                      maxLengthEnforced: true,
                      controller: _usernameController,
                      onChanged:  (String s){
                        setState(() {
                          _username = s;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    new TextField(
                      style: currentTheme.textTheme.bodyText2,
                      decoration: buildInputDecoration("Password"),
                      enabled: true,
                      maxLength: 30,
                      obscureText: true,
                      maxLengthEnforced: true,
                      controller: _passwordController,
                      onChanged:  (String s){
                        setState(() {
                          _password = s;
                        });
                      },
                    ),
                    SizedBox(height: 50),
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
                    )
                  ],
                ))
        )
    );
  }
}
