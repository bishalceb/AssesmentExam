
import 'package:assesment/model/UserDetail.dart';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:flutter/material.dart';

class UserDetailController {
  final UserDetailListener listener;
  UserDetailController({@required this.listener});

  void callAPI(String userid, String password) async{
    try{
      UserDetailApi userDetail = await userDetailApi(
          {'Client-Service': 'frontend-client', 'Auth-Key' : 'simplerestapi', 'Content-Type':'application/x-www-form-urlencoded'},
          {'module' : 'users', 'service' : 'login','username' : "sumit",'password' : "India@0987"});
      listener.onLoginSuccess(model: userDetail);

    }catch(e){
      print(e);
      listener.onLoginFailure(message: e.toString());
    }
  }
}

abstract class UserDetailListener {
  void onLoginFailure ({ @required String message });
  void onLoginSuccess ({@required UserDetailApi model});
}