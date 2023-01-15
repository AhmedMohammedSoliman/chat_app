import 'package:chat_app/add_room/add_room_screen.dart';
import 'package:chat_app/chat_screen/chat_screen.dart';
import 'package:chat_app/home/home_view_model.dart';
import 'package:chat_app/home/roomWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../add_room/roomModel.dart';
import '../dataBase/firebBasefuns.dart';
import 'home_navigator.dart';

class HomeScreen extends StatefulWidget{

  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeNavigator{

  HomeViewModel viewModel = HomeViewModel();

  @override
  void initState() {
    viewModel.navigator = this;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Image(image: AssetImage("assets/images/back_ground.png") , fit: BoxFit.fill , width: double.infinity
            , ),
          Scaffold(
            appBar: AppBar(
              title: Text("Home"),
            ),
            body: StreamBuilder<QuerySnapshot<RoomModel>>(
              stream: FireBaseFunc.getRoomsFromFireBase(),
                builder: (context , asyncSnapShot) {
                if (asyncSnapShot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }else if (asyncSnapShot.hasError){
                  return Column(
                    children: [
                      Text("SoneThine went wrong"),
                      SizedBox(height: 10,),
                      ElevatedButton(
                          onPressed: (){
                            FireBaseFunc.getRoomsFromFireBase();
                          },
                          child: Text("Try again"))
                    ],
                  );
                }else {
                  var roomList = asyncSnapShot.data?.docs.map((doc) => doc.data()).toList();
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: GridView.builder(
                      itemCount: roomList?.length ,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2 ,
                          mainAxisSpacing: 10 ,
                          crossAxisSpacing: 10
                        ),
                        itemBuilder: (context , index) => InkWell(
                          onTap: (){
                            navigateToChat(roomList![index]);
                          },
                          child: RoomWidget(title: roomList?[index].titleRoom ?? "",
                            image: "assets/images/${roomList?[index].categoryId ?? ""}.png"),
                        )),
                  );
                }
                }
                ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                navigateToAdd();
              },
              child: Icon(Icons.add),
            ),
      )
      ]
      ),
    );
  }
  @override
  void navigateToAdd() {
  Navigator.pushNamed(context, AddScreen.routeName);
  }
  @override
  void navigateToChat(RoomModel room) {
    Navigator.pushNamed(context, ChatScreen.routeName, arguments: {
      "room_title" : room.titleRoom ,
      "room" : room ,
      "roomId" : room.roomId
    });
  }


}
