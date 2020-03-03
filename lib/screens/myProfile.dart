import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redditreader_flutter/models/trophy.dart';
import 'package:redditreader_flutter/models/user.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/widgets/drawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/widgets/trophyBuilder.dart';
import '../styles/theme.dart'; // import theme of app
import '../widgets/appBar.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool homepage=true;
  bool popular=false;
  TextStyle homeText = currentTheme.textTheme.headline1;
  TextStyle popularText = TextStyle(fontSize: 26.0,color: currentTheme.primaryColor);
  Widget currentPage;

  @override
  initState(){
    _loadTrophies();
    super.initState();
  }

  Future<List<Trophy>> _loadTrophies()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/api/v1/user/${User.username}/trophies'), headers: headers);
    var jsonData = json.decode(data.body);
    List<Trophy> trophies = [];
    print('RR: $jsonData');
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadTrophies());
    }else{
      for(var postData in jsonData['data']['trophies']){
        var p = postData['data'];
        Trophy trophy;
        trophy = new Trophy(p['name'], p['icon_70']);
        trophies.add(trophy);
      }
      return trophies;
    }
  }


  // content of the screen
  @override
  Widget build(BuildContext context) {
     return Scaffold(
         extendBodyBehindAppBar: true,
        appBar: RedditReaderAppBar(),
        drawer: RedditReaderDrawer(),
        body: Padding(
            padding: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(height: 200, decoration: BoxDecoration(color: currentTheme.primaryColor)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 120, 20, 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Container(
                                        width: 120.0,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                User.profileURL,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        )
                                    )
                                ),
                              ],
                            ),
                            Row(children: <Widget>[Text(User.username, style: currentTheme.textTheme.headline1,)],),
                            SizedBox(height: 60,),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text('Karma', style: currentTheme.textTheme.headline2,),
                                        Text('Age', style: currentTheme.textTheme.headline2,),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.insert_chart, size: 25,),
                                            SizedBox(width: 5,),
                                            Text(User.karma.toString(), style: currentTheme.textTheme.bodyText1,),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.cake, size: 25),
                                            SizedBox(width: 5,),
                                            Text('${User.accountAge}${User.accountAgePostfix}', style: currentTheme.textTheme.bodyText1,),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ),
                            SizedBox(height: 20,),
                            futureTrophyBuilder(_loadTrophies())
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
        )
    );
  }
}
