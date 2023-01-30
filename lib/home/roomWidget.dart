import 'package:chat_app/chat_screen/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget{
  String image ;
  String title ;
  RoomWidget({required this.title , required this.image
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20) ,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image(image: AssetImage(image) , height: 100,) ,
          SizedBox(height: 20,) ,
          Text("$title" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}