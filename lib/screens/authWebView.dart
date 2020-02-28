import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:redditreader_flutter/utils/slides.dart';
import '../utils/redditAPI.dart';
import '../screens/homePage.dart';

class AuthWebView extends StatefulWidget {
  AuthWebView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AuthWebViewState createState() => _AuthWebViewState();
}

class _AuthWebViewState extends State<AuthWebView> {
  var _url = authorizeURL();
  final flutterWebViewPlugin = new FlutterWebviewPlugin(); // flutter web plugin

  void writeTokensStorage(Map<String, String> tokenMap){
    final storage = new FlutterSecureStorage();
    storage.write(key: 'accessToken', value: tokenMap['accessToken']);
    storage.write(key: 'refreshToken', value: tokenMap['refreshToken']);
    updateUser().then((value) => (){
      print("RR: YASSSS2");
    });
    print("RR: YASSSS");
    Route route = SlideRight(builder: (context) => HomePage());
    Navigator.push(context, route);
    flutterWebViewPlugin.close();
  }

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if(url.startsWith("$redirectURI")){
        if(url.contains('access_denied')){
          Navigator.pushNamed(context, '/Login', arguments:{
            'message':Text('ACCESS DENIED.', style: TextStyle(color: Colors.redAccent))
          });
          flutterWebViewPlugin.close();
        }
        else {
          String _code = url.substring( // Retrieve the authorization code
            url.indexOf('code=')+5,
            url.length,
          );

          // retrieve access token and refresh token and store them
          getAccessToken(_code).then((value) => writeTokensStorage(value));

        }

      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: _url,
      hidden: true,
    );
  }
}
