import 'package:intl/intl.dart';

String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var format = new DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0) {
    if(diff.inMinutes==0){
      time = 'Now';
    }
     if(diff.inMinutes > 0 && diff.inHours == 0){
      time = '${diff.inMinutes.toString()}m';
    }else{
       time = '${diff.inHours.toString()}h';
     }
  } else if(diff.inHours > 0 && diff.inDays == 0){
    time = '${diff.inHours.toString()}h';
  }else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'd';
    } else {
      time = diff.inDays.toString() + 'd';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + 'w';
    } else {

      time = (diff.inDays / 7).floor().toString() + 'w';
    }
  }

  return time;
}