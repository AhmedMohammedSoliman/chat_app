import 'package:chat_app/add_room/roomModel.dart';
import 'package:chat_app/chat_screen/messageModel.dart';
import 'package:chat_app/dataBase/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseFunc {

 static CollectionReference<MyUser> getCollectionFromFireBase (){   /// add user
    return FirebaseFirestore.instance.collection('user').withConverter<MyUser>(
        fromFirestore: (snapshot, _) => MyUser.fromJson(snapshot.data()!),
        toFirestore: (note, _) => note.toJson()
    );
  }

 static CollectionReference<RoomModel> getCollectionFromFireBaseTwo(){                   /// add room
   return FirebaseFirestore.instance.collection('rooms').withConverter<RoomModel>(
       fromFirestore: (snapshot, _) => RoomModel.fromJson(snapshot.data()!),
       toFirestore: (room, _) => room.toJson()
   );
  }

  static Future<void> addRoomToFireBase(RoomModel roomModel)async{
        var collection = getCollectionFromFireBaseTwo();
         var doc = collection.doc();
         roomModel.roomId = doc.id ;
      return doc.set(roomModel);
  }
   static Stream<QuerySnapshot<RoomModel>> getRoomsFromFireBase(){
   return  getCollectionFromFireBaseTwo().snapshots();
   }


  static Future<void> saveData(MyUser user) async{
  return getCollectionFromFireBase().doc(user.id).set(user);
   }

   static Future<MyUser?> getUserFromFireBase(String userId)async{
   var documentSnapShot =await getCollectionFromFireBase().doc(userId).get();
  return documentSnapShot.data();
   }

   static CollectionReference<MessageModel> getCollecionMessageFromFireBase (String roomId){
    return  FirebaseFirestore.instance.collection('rooms').doc(roomId).collection("messages")
        .withConverter<MessageModel>(
         fromFirestore: (snapshot, _) => MessageModel.fromJson(snapshot.data()!),
         toFirestore: (message, _) => message.toJson()
     );
   }

   static Future<void> addMessageToFireBase (MessageModel message){
      var collection = getCollecionMessageFromFireBase(message.roomId);
      var doc = collection.doc();
      message.id = doc.id ;
     return doc.set(message);
   }

   static Stream<QuerySnapshot<MessageModel>> getMessageFromFireBase (String roomId){
     return getCollecionMessageFromFireBase(roomId).orderBy("date").snapshots();

   }
}


