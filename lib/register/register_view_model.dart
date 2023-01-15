import 'package:chat_app/dataBase/firebBasefuns.dart';
import 'package:chat_app/dataBase/userModel.dart';
import 'package:chat_app/register/register_interFace_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../fireBase_errors.dart';

class RegisterViewModel extends ChangeNotifier{


 late RegisterInterFaceViewModer  navigator ;

  void FireBaseRegisterLogic(String email , String password , String firstName , String lastName ,
      String userName)async{
    navigator.showLoading();
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,

      );
      // save data
      MyUser user = MyUser(id: credential.user?.uid ?? "", firstName: firstName, lastName: lastName, userName: userName, email: email);
      var userData = await FireBaseFunc.saveData(user);

      navigator.hideLoading();
      navigator.showMessage("Register successfully");
      navigator.navigateToHome(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == FireBaseErrors.weakPassword) {
        navigator.showLoading();
        navigator.showMessage("The password provided is too weak.");
        print('The password provided is too weak.');
      } else if (e.code ==  FireBaseErrors.emailAlreadyInUse) {
        navigator.showMessage('The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      navigator.showMessage("Something went wrong");
      print(e);
    }
  }
}