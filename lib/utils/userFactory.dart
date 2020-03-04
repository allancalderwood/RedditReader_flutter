import 'package:redditreader_flutter/models/userOther.dart';


void userFactory(var jsonData, List<UserOther> users){
  for(var y in jsonData['data']['children']){

    var userData = y['data'];
    var karma = ( (userData['link_karma']) + (userData['comment_karma']));
    int seconds = ( userData['created'] /10).floor();
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
    var accountAge = age;
    var accountAgePostfix = message;

    UserOther profile = new UserOther(userData['name'], userData['icon_img'].toString(), karma, accountAge, accountAgePostfix);
    users.add(profile);
  }
}