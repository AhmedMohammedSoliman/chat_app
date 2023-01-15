import 'package:chat_app/dataBase/userModel.dart';
import 'package:chat_app/fireBase_errors.dart';
import 'package:chat_app/home/home_screen.dart';
import 'package:chat_app/login/login_navigtor.dart';
import 'package:chat_app/login/login_view_model.dart';
import 'package:chat_app/userProvider/userProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../register/registerScreen.dart';

class LoginScreen extends StatefulWidget {

  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginNavigator{
  String email = "" ;

  String password = "" ;

  var formKey = GlobalKey<FormState>();

  LoginViewModel viewModel = LoginViewModel();

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
              title: Text("Login"),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
                      TextButton(onPressed: (){

                      }, child: Text("Forget your password ?" , style : TextStyle(color : Colors.black ,
                        fontSize: 20 , fontWeight: FontWeight.w400
                      ))),
                      SizedBox(height: 30,),
                      ElevatedButton.icon(
                          onPressed: (){
                            signIn();
                          },
                          label: Text("Login" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold ,
                          fontSize: 20),) ,
                        icon: Icon(Icons.arrow_forward),),
                      SizedBox(height: 30,),
                      TextButton(onPressed: (){
                         Navigator.pushNamed(context, RegisterScreen.routeName);
                      }, child: Text("Or create an account" , style : TextStyle(color : Colors.black ,
                          fontSize: 20 , fontWeight: FontWeight.w400
                      ))),
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

  void signIn () async {
    if (formKey.currentState?.validate() == true){
      viewModel.loginTOFireBaseLogic(email, password);
    }
  }

  @override
  hideLoading() {
    Navigator.pop(context);
  }

  @override
  showLoading() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Row (
            children: [
              Text ("Loading..."),
              CircularProgressIndicator()
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
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Ok"))
          ],
        ));
  }

  @override
  navigateToHome(MyUser user) {
    var provider = Provider.of<UserProvider>(context , listen:  false);
    provider.user = user ;
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }
}
