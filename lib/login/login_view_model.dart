import 'package:chat_app/dataBase/userModel.dart';
import 'package:chat_app/login/login_navigtor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../dataBase/firebBasefuns.dart';
import '../fireBase_errors.dart';

class LoginViewModel extends ChangeNotifier{

  late LoginNavigator navigator ;

  void loginTOFireBaseLogic (String email , String password) async {
    navigator.showLoading();
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      MyUser? userObject =await FireBaseFunc.getUserFromFireBase(credential.user?.uid ?? "");
      if (userObject != null){
       navigator.navigateToHome(userObject);
      }
      print("userId : ${credential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      if (e.code == FireBaseErrors.userNotFound) {
        navigator.showMessage('No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == FireBaseErrors.wrongPassword) {
        navigator.showMessage('Wrong password provided for that user.');
        navigator.hideLoading();
        print('Wrong password provided for that user.');
      }
    }
  }
}