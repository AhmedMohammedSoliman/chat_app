import 'package:chat_app/dataBase/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class RegisterInterFaceViewModer {

  showLoading();
  hideLoading();
  showMessage(String message);
  navigateToHome(MyUser user);
}
