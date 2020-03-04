import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redditreader_flutter/screens/login.dart';
import 'package:redditreader_flutter/screens/register.dart';
import 'styles/theme.dart'; // import theme of app

void main() => runApp(RedditReader());

final storage = new FlutterSecureStorage();
bool darkTheme = true;

class RedditReader extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return AppBuilder(builder: (context){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        title: 'RedditReader',
        theme: currentTheme,
        routes: <String, WidgetBuilder>{
          "/Login": (BuildContext context)=> new LoginPage(),
          "/Register": (BuildContext context)=> new RegisterPage(),
        },
        home: LoginPage(title: 'Login or Register'),
      );
    });
  }
}

class AppBuilder extends StatefulWidget {
  final Function(BuildContext) builder;

  const AppBuilder(
      {Key key, this.builder})
      : super(key: key);

  @override
  AppBuilderState createState() => new AppBuilderState();

  static AppBuilderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<AppBuilderState>());
  }
}

class AppBuilderState extends State<AppBuilder> {

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}