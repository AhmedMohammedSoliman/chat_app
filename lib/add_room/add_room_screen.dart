import 'dart:async';
import 'package:chat_app/add_room/add_room_navigator.dart';
import 'package:chat_app/add_room/add_room_view_model.dart';
import 'package:chat_app/category/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget{
  static const String routeName = "add";

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> implements AddRoomNavigator {
  String title  = "";
  String description = "" ;

  List<CategoryModel> categoryList = [
  CategoryModel(titleCategory: "Sports", imageCategory: "assets/images/sports.png" , id: CategoryModel.sportsId) ,
  CategoryModel(titleCategory: "Music", imageCategory: "assets/images/music.png" , id: CategoryModel.musicId),
  CategoryModel(titleCategory: "Movies", imageCategory: "assets/images/movies.png" , id: CategoryModel.moviesId)];

  CategoryModel? selectedCategory;
  var formKey = GlobalKey<FormState>();

  AddRoomViewModel viewModel = AddRoomViewModel() ;
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
                title: Text("Add room"),
              ),
              body: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Create room" , style: TextStyle(color: Colors.black , fontSize: 20 , fontWeight: FontWeight.bold)
                            ),
                            Icon(Icons.groups_rounded , color: Colors.blue, size: 100,),
                            SizedBox(height: 20,),
                            TextFormField(
                              onChanged: (text){
                                title = text ;
                              },
                              validator: (text){
                                if(text == null || text.trim().isEmpty){
                                  return "Please this is required";
                                }else{
                                  return null ;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Room title" ,
                                enabledBorder: OutlineInputBorder()
                              ),
                            ),
                            SizedBox(height: 20,),
                            DropdownButton<CategoryModel>(
                              isExpanded: true,
                              value: selectedCategory,
                                items: categoryList.map((category) => DropdownMenuItem<CategoryModel>(
                                  value: category,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(category.titleCategory),
                                        SizedBox(height: 10,),
                                        Image(image: AssetImage(category.imageCategory) , height: 30,)
                                      ],
                                    ))).toList(),
                                onChanged: (newCategory){
                                   selectedCategory = newCategory ;
                                   setState((){});
                                }),
                            SizedBox(height: 20,),
                            TextFormField(
                              onChanged: (text){
                                description = text ;
                              },
                              validator: (text){
                                if(text == null || text.trim().isEmpty){
                                  return "Please this is required";
                                }else{
                                  return null ;
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Room description" ,
                                  enabledBorder: OutlineInputBorder()
                              ),
                            ),
                            SizedBox(height: 20,),
                            ElevatedButton(
                                onPressed: (){
                                   addRoom();
                                },
                                child: Text("Add room" , style: TextStyle(fontSize: 18),))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )

            )
          ]
      ),
    );
  }
  void addRoom (){
    if(formKey.currentState?.validate() == true){
   viewModel.addRoomFunc(title, description, selectedCategory?.id ?? "");
    }
  }

  @override
  void hideLoading() {
    Navigator.pop(context);
  }

  @override
  void showLoading() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              Text("Loading ...."),
              SizedBox(width: 20,),
              CircularProgressIndicator(),
            ],
          ),
        ));
  }

  @override
  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              Text(message),
            ],
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Ok"))
          ],
        ));
  }
  @override
  void navigateToHome() {
    Timer(Duration(seconds: 2) , () => Navigator.pop(context),);
  }
}