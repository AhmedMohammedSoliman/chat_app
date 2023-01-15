import 'package:chat_app/dataBase/firebBasefuns.dart';
import 'package:chat_app/dataBase/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{

  MyUser? user ;
  User? fireBaseUser ;

  UserProvider(){

    fireBaseUser = FirebaseAuth.instance.currentUser;
    initUser() ;
  }

  void initUser ()async {
    if(fireBaseUser != null){
      user = await FireBaseFunc.getUserFromFireBase(fireBaseUser?.uid ?? "");
    }
  }

}