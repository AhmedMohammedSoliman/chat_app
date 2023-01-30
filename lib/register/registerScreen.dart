
import 'package:chat_app/dataBase/userModel.dart';
import 'package:chat_app/home/home_screen.dart';
import 'package:chat_app/register/register_interFace_view_model.dart';
import 'package:chat_app/register/register_view_model.dart';
import 'package:chat_app/userProvider/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../fireBase_errors.dart';



class RegisterScreen extends StatefulWidget {

  static const String routeName = "register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> implements RegisterInterFaceViewModer {
  String firstName = "" ;

  String lastName = "" ;

  String email = "";

  String password = "" ;

  String userName = "";


  var formKey = GlobalKey<FormState>();

  RegisterViewModel viewModel = RegisterViewModel();

  @override
  void initState() {
   viewModel.navigator = this ;
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
              title: Text("Register"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Welcome back !" , style: Theme.of(context).textTheme.headline1,) ,
                      SizedBox(height: 30,),
                      Form(
                        key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (text){
                                  if (text== null  || text.trim().isEmpty){
                                    return "This field is required";
                                  }else {
                                    return null ;
                                  }
                                },
                                onChanged: (text){
                                  firstName = text ;
                                },
                                decoration: InputDecoration(
                                    hintText: "Enter your first name" ,
                                    suffixIcon: Icon(Icons.person),
                                    enabledBorder: UnderlineInputBorder()
                                ),
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                validator: (text){
                                  if (text== null  || text.trim().isEmpty){
                                    return "This field is required";
                                  }else {
                                    return null ;
                                  }
                                },
                                onChanged: (text){
                                  lastName = text ;
                                },
                                decoration: InputDecoration(
                                    hintText: "Enter your last name" ,
                                    suffixIcon: Icon(Icons.person),
                                    enabledBorder: UnderlineInputBorder()
                                ),
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                validator: (text){
                                  if (text== null  || text.trim().isEmpty){
                                    return "This field is required";
                                  }else {
                                    return null ;
                                  }
                                },
                                onChanged: (text){
                                  userName = text ;
                                },
                                decoration: InputDecoration(
                                    hintText: "Enter your user name" ,
                                    suffixIcon: Icon(Icons.person),
                                    enabledBorder: UnderlineInputBorder()
                                ),
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                validator: (text){
                                  if (text== null  || text.trim().isEmpty){
                                    return "This field is required";
                                  }else {
                                    return null ;
                                  }
                                },
                                onChanged: (text){
                                  email = text ;
                                },
                                decoration: InputDecoration(
                                    hintText: "Enter your email" ,
                                    suffixIcon: Icon(Icons.email),
                                    enabledBorder: UnderlineInputBorder()
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                validator: (text){
                                  if (text== null  || text.trim().isEmpty){
                                    return "This field is required";
                                  }else {
                                    return null ;
                                  }
                                },
                                onChanged: (text){
                                  password = text ;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    suffixIcon: Icon(Icons.password),
                                    enabledBorder: UnderlineInputBorder()
                                ),
                              )
                            ],
                          )
                      ),
                      SizedBox(height: 30,),
                      ElevatedButton.icon(
                        onPressed: (){
                       createAccount();
                        },
                        label: Text("Create Account" , style: TextStyle(color: Colors.white , fontWeight:
                        FontWeight.bold , fontSize: 20)) ,
                        icon: Icon(Icons.arrow_forward),),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void createAccount ()async{
    if (formKey.currentState?.validate() == true){
      viewModel.FireBaseRegisterLogic(email, password , firstName , lastName , userName);
    }
  }

  @override
  hideLoading() {
    Navigator.pop(context);
  }

  @override
  showLoading() {
    showDialog(context: context,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              Text("Loading ...."),
              SizedBox(width: 15,),
              CircularProgressIndicator(),
            ],
          ),
        ));
  }

  @override
  showMessage(String message) {
   showDialog(
       context: context,
       builder: (context) => AlertDialog(
         content: Text(message),
         actions: [
           TextButton(
               onPressed: (){
                 Navigator.pop(context);
               },
               child: Text("Ok"))
         ],
       ));
  }
  @override
  navigateToHome(MyUser user) {
    var provider = Provider.of<UserProvider>(context, listen: false);
    provider.user = user ;
   Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }
}