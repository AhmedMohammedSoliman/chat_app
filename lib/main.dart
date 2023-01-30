
import 'package:chat_app/add_room/add_room_screen.dart';
import 'package:chat_app/chat_screen/chat_screen.dart';
import 'package:chat_app/home/home_screen.dart';
import 'package:chat_app/login/loginScreen.dart';
import 'package:chat_app/register/registerScreen.dart';
import 'package:chat_app/theme/theming.dart';
import 'package:chat_app/userProvider/userProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void getTocken()async{
  String? token = await messaging.getToken(
    vapidKey: "BGpdLRs......",
  );
  print(token);
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  /// show message
  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getTocken();
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

   await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );


  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      /// show message
       void showFlutterNotification(RemoteMessage message) {
         RemoteNotification? notification = message.notification;
         AndroidNotification? android = message.notification?.android;
         if (notification != null && android != null) {
           flutterLocalNotificationsPlugin.show(
             notification.hashCode,
             notification.title,
             notification.body,
             NotificationDetails(
               android: AndroidNotificationDetails(
                 channel.id,
                 channel.name,
                 channelDescription: channel.description,
                 // TODO add a proper drawable resource to android, for now using
                 //      one that already exists in example app.
                 icon: 'launch_background',
               ),
             ),
           );
         }
       }
    });

    super.initState();
  }
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


Future<void> onbackgrounMessage(RemoteMessage message) async {

  print (message.notification?.body);
}
