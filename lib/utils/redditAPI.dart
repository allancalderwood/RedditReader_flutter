import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:redditreader_flutter/main.dart';
import 'package:redditreader_flutter/models/user.dart';

final  String authBaseURL = 'https://www.reddit.com/api/v1/authorize.compact?';
final  String clientID = '0hTJIPhRuBBTJg';
final  String redirectURI = 'https://www.reddit.com/user/AllanCalderwood/';
final  String duration = 'permanent';
final  String _scope = 'identity edit flair history modconfig modflair modlog modposts modwiki mysubreddits privatemessages read report save submit subscribe vote wikiedit wikiread';
final  String tokenBaseURL = 'https://www.reddit.com/api/v1/access_token';
final  String _userAgent = 'android:com.redditreader.redditreader_flutter:v.1 (by /u/AllanCalderwood)';
final  String callBaseURL = "https://oauth.reddit.com";

Map<String, String> getHeader(){
  String token = User.token;
  return {'User-Agent':clientID,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Bearer $token'};
}


// Method for returning the URL for users to authorize the app
String authorizeURL(){
  String _state = _generateStateString();
  String _url = '$authBaseURL'
      'client_id=$clientID&'
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
  var _bytes = utf8.encode('$clientID:');
  var _credentials = base64.encode(_bytes);
  Map<String, String> _headers = {'User-Agent':_userAgent,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Basic $_credentials'};
  String _body = "grant_type=authorization_code&code=$codes&redirect_uri=$redirectURI";
  http.Response response = await http.post(Uri.encodeFull(tokenBaseURL), headers: _headers, body: _body);

  var responseText = json.decode(response.body);
  String _accessToken = responseText['access_token'];
  String _refreshToken = responseText['refresh_token'];
  User.token=_accessToken;
  _tokens['accessToken'] =_accessToken;
  _tokens['refreshToken'] =_refreshToken;
  return _tokens;
}

void refreshToken(){
  var _bytes = utf8.encode('$clientID:');
  var _credentials = base64.encode(_bytes);
  storage.read(key: 'refreshToken').then((value) => ()async{
    String _body = "grant_type=refresh_token&refresh_token=$value";
    Map<String, String> _headers = {'User-Agent':_userAgent,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Basic $_credentials'};
    http.Response response = await http.post(Uri.encodeFull(tokenBaseURL), headers: _headers, body: _body);

    var responseText = json.decode(response.body);
    String _accessToken = responseText['access_token'];
    User.token = _accessToken;
    storage.write(key: 'accessToken', value: _accessToken);
    updateUser();
  });
}

Future<void> refreshTokenAsync()async{
  var _bytes = utf8.encode('$clientID:');
  var _credentials = base64.encode(_bytes);
  var token = await storage.read(key: 'refreshToken');
  String _body = "grant_type=refresh_token&refresh_token=$token";
  Map<String, String> _headers = {'User-Agent':_userAgent,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Basic $_credentials'};
  http.Response response = await http.post(Uri.encodeFull(tokenBaseURL), headers: _headers, body: _body);

  var responseText = json.decode(response.body);
  String _accessToken = responseText['access_token'];
  User.token = _accessToken;
  storage.write(key: 'accessToken', value: _accessToken);
  updateUser();
}

Future<void> updateUser()async{
  Map<String, String> _headers = {'User-Agent':_userAgent,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Bearer ${User.token}'};
  http.Response response = await http.get(Uri.encodeFull(callBaseURL+'/api/v1/me'), headers: _headers);

  var responseText = json.decode(response.body);
    User.username = responseText['name'];
    User.karma = ( (responseText['link_karma']) + (responseText['comment_karma']) );
    User.profileURL = responseText['icon_img'].toString();
    int seconds = ( responseText['created'] /10).floor();
    int daysSince = (seconds/86400).floor();
    var age;
    String message = 'days old';

    if(daysSince>30 && daysSince<365){
      daysSince =  (daysSince/30).floor();
      age = daysSince.floor().toInt();
      message =  'mnths old';
    }
    else if(daysSince>365){
      daysSince =  (daysSince/365).floor();
      age = daysSince.floor().toInt();
      message = 'yr old';
    }else{
      age = daysSince.floor().toInt();
    }
    User.accountAge = age;
    User.accountAgePostfix = message;
    User.updated=true;
    User.storeUser();
}

Future<void> logOutUser()async{
  var _bytes = utf8.encode('$clientID:');
  var _credentials = base64.encode(_bytes);

  Map<String, String> _headers = {'User-Agent':_userAgent,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Basic $_credentials'};
  String _body = "token=${User.token}&token_type_hint=access_token";
  http.post(Uri.encodeFull("https://www.reddit.com/api/v1/revoke_token"), headers: _headers, body: _body);

  String rToken = await storage.read(key: 'refreshToken');
  String _body2 = "token=$rToken&token_type_hint=refresh_token";
  http.post(Uri.encodeFull("https://www.reddit.com/api/v1/revoke_token"), headers: _headers, body: _body2);
}

void vote(String id, int vote)async{
  Map<String, String> _headers = {'User-Agent':clientID,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Bearer ${User.token}'};
  String _body = "id=$id&dir=$vote";
  http.Response response = await http.post(Uri.encodeFull(callBaseURL+'/api/vote'), headers: _headers, body: _body);
}

void save(String id, String category)async{
  Map<String, String> _headers = {'User-Agent':clientID,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Bearer ${User.token}'};
  String _body = "id=$id&category=$category";
  http.Response response = await http.post(Uri.encodeFull(callBaseURL+'/api/vote'), headers: _headers, body: _body);
}

void unsave(String id)async{
  Map<String, String> _headers = {'User-Agent':clientID,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Bearer ${User.token}'};
  String _body = "id=$id";
  http.Response response = await http.post(Uri.encodeFull(callBaseURL+'/api/vote'), headers: _headers, body: _body);
}

void subscribe(String sr, String action)async{
  bool skipDefaults = true;
  Map<String, String> _headers = {'User-Agent':clientID,"Content-type": "application/x-www-form-urlencoded", 'Authorization':'Bearer ${User.token}'};
  String _body = "action=$action&skip_initial_defaults=$skipDefaults&sr_name=${sr}";
  http.Response response = await http.post(Uri.encodeFull(callBaseURL+'/api/subscribe'), headers: _headers, body: _body);
}