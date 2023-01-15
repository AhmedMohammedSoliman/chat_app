import 'package:chat_app/add_room/roomModel.dart';

abstract class HomeNavigator {

  void navigateToAdd();
  void navigateToChat(RoomModel room);
}