import 'package:chat_app/chat_screen/chat_screen_viewModel.dart';
import 'package:chat_app/chat_screen/messageModel.dart';
import 'package:chat_app/chat_screen/messageWidget.dart';
import 'package:chat_app/dataBase/firebBasefuns.dart';
import 'package:chat_app/userProvider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_screen_navigator.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = "chat" ;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> implements ChatNavigator {
  String roomTitle = "" ;

  String messageContent = "" ;

  ChatScreenViewModel viewModel = ChatScreenViewModel();
  late TextEditingController controller ;



  @override
  void initState() {
    viewModel.navigator = this  ;
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as Map ;
    var provider = Provider.of<UserProvider>(context);
    viewModel.user = provider.user! ;
    viewModel.room = args["room"];
    return ChangeNotifierProvider(
      create : (context) => viewModel,
      child: Stack(
        children: [
        Container(
        color: Colors.white,
      ),
      Image(image: AssetImage("assets/images/back_ground.png") , fit: BoxFit.fill , width: double.infinity
      , ),
      Scaffold(
      appBar: AppBar(
      title: Text("Welcome to room : ${args["room_title"]}"),
      ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white ,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot<MessageModel>>(
                      stream: FireBaseFunc.getMessageFromFireBase(args["roomId"]),
                        builder: (context , asyncSnapShot) {
                          if (asyncSnapShot.connectionState == ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator(),);
                          }else if (asyncSnapShot.hasError){
                            return Column(
                              children: [
                                Text("Error happended") ,
                                SizedBox(height: 20,),
                                ElevatedButton(
                                    onPressed: (){
                                      FireBaseFunc.getMessageFromFireBase(args["roomId"]);
                                    },
                                    child: Text("Try again"))
                              ],
                            );
                          } else {
                            // data
                            var messageList = asyncSnapShot.data?.docs.map((doc) => doc.data()).toList() ?? [];
                            return ListView.separated(
                                itemBuilder: (context, index) => MessageWidget(
                                    content: messageList[index].content,
                                    messageModel: messageList[index]),
                                separatorBuilder: (context , index) => SizedBox(height: 10,),
                                itemCount: messageList.length);
                          }
                        })),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                            controller: controller,
                             onChanged: (text){
                               messageContent = text ;
                             },
                            decoration: InputDecoration(
                                hintText: "Type your message here",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black , width: 3),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(20) ,
                                  bottomLeft: Radius.circular(20))
                                )
                            ),
                          ) ,),
                      SizedBox(width: 10,),
                      ElevatedButton(
                          onPressed: (){
                           addMessageFun(messageContent);
                           controller.clear();
                          },
                          child: Row(
                            children: [
                              Text("Send"),
                              SizedBox(width: 10,),
                              Icon(Icons.send)
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
      ]
      ),
    );
  }
  void addMessageFun(String content)async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile){
      viewModel.addMessage(content) ;
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
      Text("Please check our internet and try again ")));
    }

  }
}
