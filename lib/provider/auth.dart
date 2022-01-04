import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_error.dart';

class Auth with ChangeNotifier {
  String? _userId = null;
  DateTime? _expiryDate = null;
  String? _token = null;
  Timer? _authTimer;


  bool get isAuth {
    return _token != null;
  }
  String? get userId{ return  _userId;}

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAxDK_Dsd1yabafLZ1B4DTBRyl-Eswo1QU");

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpError(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();

      final pref = await SharedPreferences.getInstance();
      final storedData = {
        'userID' : _userId,
        'expiryDate' : _expiryDate!.toIso8601String(),
        'token':_token

      };
      pref.setString('userData', json.encode(storedData));

      notifyListeners();

    } catch (error) {
      throw error;
    }
  }

  Future<bool> autoLogging() async{
    final pref = await SharedPreferences.getInstance();
    if(!pref.containsKey('userData')) {
      return false;
    }
    final storedUserData = json.decode(pref.getString("userData")!) as Map<String, dynamic>;
    final expiryData = DateTime.parse(storedUserData['expiryDate']);

    if(expiryData.isBefore(DateTime.now())) return false;

    _token = storedUserData['token'];
    _userId = storedUserData['userID'];
    _expiryDate = expiryData;

    notifyListeners();
    return true;

  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAxDK_Dsd1yabafLZ1B4DTBRyl-Eswo1QU");

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpError(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();


      final pref = await SharedPreferences.getInstance();
      final storedData = {
        'userID' : _userId,
        'expiryDate' : _expiryDate!.toIso8601String(),
        'token':_token

      };
      pref.setString('userData', json.encode(storedData));


      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async{
    _userId=null;
    _expiryDate=null;
    _token=null;
    if(_authTimer!=null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }

  void _autoLogout(){
    if(_authTimer!=null){
      _authTimer!.cancel();
      _authTimer = null;
    }

    final timeTOExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeTOExpire), logout);





  }
}
