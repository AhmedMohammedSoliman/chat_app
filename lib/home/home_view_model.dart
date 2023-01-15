import 'package:chat_app/add_room/roomModel.dart';
import 'package:flutter/cupertino.dart';

import 'home_navigator.dart';

class HomeViewModel extends ChangeNotifier{
  late HomeNavigator navigator ;

  void navigateToAddFunc (){
    navigator.navigateToAdd();
  }
  void navigateToChatFun(RoomModel room){
    navigator.navigateToChat(room);
  }
}