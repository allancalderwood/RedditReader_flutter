import 'package:flutter/material.dart';
import 'package:redditreader_flutter/screens/login.dart';
import 'package:redditreader_flutter/styles/inputDecoration.dart';
import '../styles/theme.dart'; // import theme of app
import '../utils/slides.dart'; // import slide animations

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordConfirmController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  String _username = "";
  String _password = "";
  String _passwordConfirm = "";
  String _email = "";

  void _attemptRegister() {  // TODO login functionality
    print(_username.toString());
    print(_email.toString());
    print(_password.toString());
    print(_passwordConfirm.toString());
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
                      decoration: buildInputDecoration("Email"),
                      enabled: true,
                      maxLength: 30,
                      obscureText: true,
                      maxLengthEnforced: true,
                      controller: _emailController,
                      onChanged:  (String s){
                        setState(() {
                          _password = s;
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
                    SizedBox(height: 30),
                    new TextField(
                      style: currentTheme.textTheme.bodyText2,
                      decoration: buildInputDecoration("Confirm Password"),
                      enabled: true,
                      maxLength: 30,
                      obscureText: true,
                      maxLengthEnforced: true,
                      controller: _passwordConfirmController,
                      onChanged:  (String s){
                        setState(() {
                          _passwordConfirm = s;
                        });
                      },
                    ),
                    SizedBox(height: 50),
                    FlatButton(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        onPressed: _attemptRegister,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                        ),
                        color: currentTheme.primaryColor,
                        child: const Text('Register')
                    ),
                    SizedBox(height: 30),
                    FlatButton(
                        onPressed: (){
                          Route route = SlideLeft(builder: (context) => LoginPage());
                          Navigator.push(context, route);
                        },
                        padding: EdgeInsets.all(0),
                        child: Text('Go back?', style: TextStyle(fontSize: 14.0, color: currentTheme.accentColor))
                    )
                  ],
                ))
        )
    );
  }
}
