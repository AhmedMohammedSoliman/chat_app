import 'package:chat_app/add_room/add_room_screen.dart';
import 'package:chat_app/chat_screen/chat_screen.dart';
import 'package:chat_app/home/home_view_model.dart';
import 'package:chat_app/home/roomWidget.dart';
import 'package:chat_app/userProvider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
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
  Widget build(BuildContext context){
    var provider = Provider.of<UserProvider>(context);
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Please check your internet"),
                        SizedBox(height: 10,),
                        ElevatedButton(
                            onPressed: (){
                              FireBaseFunc.getRoomsFromFireBase();
                            },
                            child: Text("Try again"))
                      ],
                    ),
                  );
                }else {
                  var roomList = asyncSnapShot.data?.docs.map((doc) => doc.data()).toList();

                 return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text("Welcome : ${provider.user!.userName}" ,maxLines: 2
                                ,overflow:TextOverflow.ellipsis ,
                                style: TextStyle(color: Colors.white ,
                                    fontSize: 20 , fontWeight: FontWeight.bold),),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: IconButton(
                                  onPressed: () => showSearch(context: context, delegate: searchdelegate()),
                                  icon: Icon(Icons.search , size: 30, color: Colors.black,)),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
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
                                onTap: ()async{
                                  var connectivityResult = await (Connectivity().checkConnectivity());
                                  if(connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile){
                                    navigateToChat(roomList![index]);
                                  }else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                                    Text("Please check your internet and try again ")));
                                  }

                                },
                                child: RoomWidget(title: roomList?[index].titleRoom ?? "",
                                    image: "assets/images/${roomList?[index].categoryId ?? ""}.png"),
                              )),
                        ),
                      )
                    ],
                  ) ;
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
class searchdelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
   return [
     IconButton(
         onPressed: ()async{
           var connectivityResult = await (Connectivity().checkConnectivity());
           if(connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile){
             showResults(context);
           }else {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
             Text("Please check your internet and try again ")));
           }

     }, icon: Icon(Icons.search , size: 25,))
   ] ;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.cancel , size: 25,));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot<RoomModel>>(
        stream: FireBaseFunc.getRoomsFromFireBase(),
        builder: (context , asyncSnapShot) {
          if (asyncSnapShot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if (asyncSnapShot.hasError){
            return Column(
              children: [
                Text("Please check your internet"),
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
            var filteredList = roomList?.where((room) =>
                room.titleRoom.toLowerCase().contains(query.toLowerCase())).toList();
            return Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 30),
                child: query == "" ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2 ,
                        mainAxisSpacing: 10 ,
                        crossAxisSpacing: 10
                    ),
                    itemCount: roomList!.length ,
                    itemBuilder: (context , index) => InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, ChatScreen.routeName , arguments: {
                          "room_title" : roomList[index].titleRoom ,
                          "room" : roomList[index] ,
                          "roomId" : roomList[index].roomId
                        } );
                      },
                      child: RoomWidget(title: roomList[index].titleRoom,
                          image: "assets/images/${roomList[index].categoryId}.png"),
                    )) : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2 ,
                        mainAxisSpacing: 10 ,
                        crossAxisSpacing: 10
                    ),
                    itemCount: filteredList!.length ,
                    itemBuilder: (context , index) => InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, ChatScreen.routeName , arguments: {
                          "room_title" : filteredList[index].titleRoom ,
                          "room" : filteredList[index] ,
                          "roomId" : filteredList[index].roomId
                        } );
                      },
                      child: RoomWidget(title: filteredList[index].titleRoom,
                          image: "assets/images/${filteredList[index].categoryId}.png"),
                    )),
              ),
            );
          }
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text("suggestions" , style: TextStyle(color: Colors.white),));
  }

}
