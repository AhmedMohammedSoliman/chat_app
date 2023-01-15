import 'package:chat_app/add_room/add_room_navigator.dart';
import 'package:chat_app/add_room/roomModel.dart';
import 'package:chat_app/dataBase/firebBasefuns.dart';
import 'package:flutter/cupertino.dart';

class AddRoomViewModel extends ChangeNotifier{

   late AddRoomNavigator navigator ;
  void addRoomFunc(String titleRoom , String descriptionRoom , String categoryId ){
    RoomModel roomModel = RoomModel(
        roomId: "", titleRoom:
    titleRoom, descriptionRoom:
    descriptionRoom, categoryId:
    categoryId);
    try{
      var room = FireBaseFunc.addRoomToFireBase(roomModel);
      navigator.showLoading();
      navigator.hideLoading();
      navigator.showMessage("Room is added");
      navigator.navigateToHome();
    }catch(e){
      navigator.showMessage("something went wrong");
    }
  }
}