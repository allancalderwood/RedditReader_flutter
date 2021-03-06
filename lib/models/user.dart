import 'package:flutter/material.dart';
import 'package:redditreader_flutter/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/utils/redditAPI.dart';

class User {
  static String _token = '';
  static String _username = 'Username';
  static String _profileURL = 'https://www.redditstatic.com/avatars/avatar_default_03_FFB000.png';
  static Image _backgroundURL;
  static int _karma = 0;
  static int _accountAge = 1;
  static String _accountAgePostfix = ' days old';
  static bool _updated = false;


  static String get token => _token;

  static set token(String value) {
    _token = value;
  }

  static String get username => _username;

  static set username(String value) {
    _username = value;
  }

  static String get profileURL => _profileURL;

  static bool get updated => _updated;

  static set updated(bool value) {
    _updated = value;
  }

  static String get accountAgePostfix => _accountAgePostfix;

  static set accountAgePostfix(String value) {
    _accountAgePostfix = value;
  }

  static int get accountAge => _accountAge;

  static set accountAge(int value) {
    _accountAge = value;
  }

  static int get karma => _karma;

  static set karma(int value) {
    _karma = value;
  }

  static set profileURL(String value) {
    _profileURL = value;
  }

  static retrieveUser(){
    storage.read(key: 'accessToken').then((value) => _token=value);
    storage.read(key: 'username').then((value) => _username=value);
    storage.read(key: 'profileURL').then((value) => _profileURL=value);
    storage.read(key: 'karma').then((value) => _karma=int.parse(value));
    storage.read(key: 'accountAge').then((value) => _accountAge=int.parse(value));
    storage.read(key: 'accountAgePostfix').then((value) => _accountAgePostfix=value);
  }

  static storeUser(){
    storage.write(key: 'username', value: _username);
    storage.write(key: 'profileURL', value: _profileURL);
    storage.write(key: 'karma', value: _karma.toString());
    storage.write(key: 'accountAge', value: _accountAge.toInt().toString());
    storage.write(key: 'accountAgePostfix', value: _accountAgePostfix);
  }

  static logOut(){
    _token = '';
    _username = 'Username';
    _profileURL = 'https://www.redditstatic.com/avatars/avatar_default_03_FFB000.png';
    _profileURL = '';
    _karma = 0;
    _accountAge = 1;
    _accountAgePostfix = ' days old';
    _updated = false;
    storage.deleteAll();
    logOutUser();
  }


}