import 'package:chat_app/userProvider/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'messageModel.dart';

class MessageWidget extends StatelessWidget{

  String content ;
  MessageModel messageModel ;
  MessageWidget({required this.content , required this.messageModel});

  @override
  Widget build(BuildContext context) {
   var  provider = Provider.of<UserProvider>(context);
    return provider.user!.id == messageModel.senderId ? sendShape() : receiveShape() ;
  }

  Widget sendShape (){
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue ,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              )
            ),
            child: Text(content, style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 5,),
          Text(messageModel.senderName, style: TextStyle(color: Colors.black)),
          SizedBox(height: 5,),
          Text(DateFormat("yyyy_MM_dd  kk:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(messageModel.date)))
        ],
      ),
    );
  }
  Widget receiveShape (){
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey ,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
            ),
            child: Text(content , style: TextStyle(color: Colors.black)),
          ),
          SizedBox(height: 5,),
          Text(messageModel.senderName, style: TextStyle(color: Colors.black)),
          SizedBox(height: 5,),
          Text(DateFormat("yyyy_MM_dd  kk:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(messageModel.date)))
        ],
      ),
    );
  }
}