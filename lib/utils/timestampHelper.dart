import 'package:intl/intl.dart';

String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var format = new DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0) {
    if(diff.inMinutes==0){
      time = 'Just now';
    }
     if(diff.inMinutes > 0 && diff.inHours == 0){
      time = '${diff.inMinutes.toString()} minutes ago';
    }else{
       time = '${diff.inHours.toString()} hours ago';
     }
  } else if(diff.inHours > 0 && diff.inDays == 0){
    time = '${diff.inHours.toString()} hours ago';
  }else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' Day ago';
    } else {
      time = diff.inDays.toString() + ' Days ago';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' Week ago';
    } else {

      time = (diff.inDays / 7).floor().toString() + ' Weeks ago';
    }
  }

  return time;
}