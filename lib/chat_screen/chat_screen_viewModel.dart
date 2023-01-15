import 'package:chat_app/add_room/roomModel.dart';
import 'package:chat_app/chat_screen/chat_screen_navigator.dart';
import 'package:chat_app/chat_screen/messageModel.dart';
import 'package:chat_app/dataBase/firebBasefuns.dart';
import 'package:chat_app/dataBase/userModel.dart';
import 'package:flutter/cupertino.dart';


class ChatScreenViewModel extends ChangeNotifier{
  late ChatNavigator navigator ;
  late MyUser user ;
  late RoomModel room ;
    void addMessage (String content) async{
    MessageModel message = MessageModel(
        roomId: room.roomId,
        senderId: user.id,
        senderName: user.userName ,
        content: content,
        date: DateTime.now().millisecondsSinceEpoch);
    try{
      var addMessage =  await FireBaseFunc.addMessageToFireBase(message);
    }catch (e){
      rethrow ;
    }
  }
}