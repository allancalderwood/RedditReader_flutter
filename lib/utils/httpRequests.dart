import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

final  String authBaseURL = 'https://www.reddit.com/api/v1/authorize.compact?';
final  String _clientID = '0hTJIPhRuBBTJg';
final  String redirectURI = 'https://www.reddit.com/user/AllanCalderwood/';
final  String duration = 'permanent';
final  String _scope = 'identity edit flair history modconfig modflair modlog modposts modwiki mysubreddits privatemessages read report save submit subscribe vote wikiedit wikiread';
final  String tokenBaseURL = 'https://www.reddit.com/api/v1/access_token';
final  String _userAgent = 'android:com.redditreader.redditreader_flutter:v.1 (by /u/AllanCalderwood)';

// Method for returning the URL for users to authorize the app
String authorizeURL(){
  String _state = _generateStateString();
  String _url = '$authBaseURL'
      'client_id=$_clientID&'
      'response_type=code&'
      'state=$_state&'
      'redirect_uri=$redirectURI&'
      'duration=$duration&'
      'scope=$_scope';

  return _url;
}

// Method for generating a random state string to determine if
// a user has completed authorization
String _generateStateString(){
   final String _symbols =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"; // allowed symbols

   String _state = '';
   final _random = new Random();

   for(int i=0; i<8; i++){
     _state+=_symbols[_random.nextInt(_symbols.length)];
   }

   return _state;
}
 Future<Map<String,String>> getAccessToken(String codes) async{
  Map<String, String> _tokens = new Map();
  var _bytes = utf8.encode('$_clientID:');
  var _credentials = base64.encode(_bytes);
  Map<String, String> _headers = {'User-Agent':_userAgent,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Basic $_credentials'};
  String _body = "grant_type=authorization_code&code=$codes&redirect_uri=$redirectURI";
  http.Response response = await http.post(Uri.encodeFull(tokenBaseURL), headers: _headers, body: _body);

  var responseText = json.decode(response.body);
  String _accessToken = responseText['access_token'];
  String _refreshToken = responseText['refresh_token'];

  _tokens['accesToken'] =_accessToken;
  _tokens['refreshToken'] =_refreshToken;
  return _tokens;
}