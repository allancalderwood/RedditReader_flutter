
import 'package:redditreader_flutter/models/user.dart';

class UserOther extends User {
  String _username = 'Username';
  String _profileURL = 'https://www.redditstatic.com/avatars/avatar_default_03_FFB000.png';
   int _karma = 0;
   int _accountAge = 1;
   String _accountAgePostfix = ' days old';

  UserOther(this._username, this._profileURL, this._karma, this._accountAge, this._accountAgePostfix);

  String get username => _username;

   set username(String value) {
    _username = value;
  }

   String get profileURL => _profileURL;

   String get accountAgePostfix => _accountAgePostfix;

   set accountAgePostfix(String value) {
    _accountAgePostfix = value;
  }

   int get accountAge => _accountAge;

   set accountAge(int value) {
    _accountAge = value;
  }

   int get karma => _karma;

   set karma(int value) {
    _karma = value;
  }

   set profileURL(String value) {
    _profileURL = value;
  }
}