
import 'package:chat_app/add_room/add_room_screen.dart';
import 'package:chat_app/chat_screen/chat_screen.dart';
import 'package:chat_app/home/home_screen.dart';
import 'package:chat_app/login/loginScreen.dart';
import 'package:chat_app/register/registerScreen.dart';
import 'package:chat_app/theme/theming.dart';
import 'package:chat_app/userProvider/userProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: provider.fireBaseUser == null ? LoginScreen.routeName : HomeScreen.routeName,
      routes: {
        RegisterScreen.routeName : (context) => RegisterScreen(),
        LoginScreen.routeName : (context) => LoginScreen(),
        HomeScreen.routeName : (context) => HomeScreen(),
        AddScreen.routeName : (context) => AddScreen(),
        ChatScreen.routeName : (context) => ChatScreen(),
      } ,
      theme : MyTheme.lightTheme,
      locale: Locale("en"),
    );
  }
}

