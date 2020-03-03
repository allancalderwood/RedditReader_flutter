import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redditreader_flutter/models/trophy.dart';
import 'package:redditreader_flutter/models/user.dart';
import 'package:redditreader_flutter/models/userOther.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';
import 'package:redditreader_flutter/widgets/drawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/widgets/trophyBuilder.dart';
import '../styles/theme.dart'; // import theme of app
import '../widgets/appBar.dart';

class MyProfile extends StatefulWidget {
  MyProfile({Key key, this.profile,  this.current}) : super(key: key);
  final UserOther profile;
  final bool current;
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  @override
  initState(){
    _loadTrophies();
    super.initState();
  }

  Future<List<Trophy>> _loadTrophies()async{
    http.Response data = await http.get(Uri.encodeFull(callBaseURL+'/api/v1/user/${widget.profile.username}/trophies'), headers: getHeader());
    var jsonData = json.decode(data.body);
    List<Trophy> trophies = [];
    if(jsonData['message']=='Unauthorized'){
      refreshTokenAsync().then((value) => _loadTrophies());
    }else{
      for(var trophyData in jsonData['data']['trophies']){
        var t = trophyData['data'];
        Trophy trophy;
        trophy = new Trophy(t['name'], t['icon_70']);
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
                                              image: NetworkImage(
                                                widget.profile.profileURL,
                                                headers: getHeader()
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
                            Row(children: <Widget>[Text(widget.profile.username, style: currentTheme.textTheme.headline1,)],),
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
                                            Icon(Icons.insert_chart, size: 25, color: Colors.blue,),
                                            SizedBox(width: 5,),
                                            Text(widget.profile.karma.toString(), style: currentTheme.textTheme.bodyText1,),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.cake, size: 25, color: Colors.orangeAccent),
                                            SizedBox(width: 5,),
                                            Text('${widget.profile.accountAge}${widget.profile.accountAgePostfix}', style: currentTheme.textTheme.bodyText1,),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ),
                            SizedBox(height: 20,),
                            (widget.current) ? futureTrophyBuilder(_loadTrophies()) : Container(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 100,),
                                  FlatButton(
                                    padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(12.0),
                                    ),
                                    color: currentTheme.primaryColor,
                                    onPressed: (){},
                                    child: Text('Message ${widget.profile.username}'),
                                  )
                                ],
                              ),
                            ),
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
