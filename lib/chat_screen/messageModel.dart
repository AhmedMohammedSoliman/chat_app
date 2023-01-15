class MessageModel {

  String id ;
  String roomId ;
  String content ;
  String senderId ;
  String senderName ;
  int date ;

  MessageModel({this.id = "" , required this.roomId , required this.senderId , required this.senderName
    , required this.content , required this.date});

  MessageModel.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    roomId: json['room_id']! as String,
    content: json['content']! as String,
    senderName: json['sender_name']! as String,
    senderId: json['sender_id']! as String,
    date: json['date']! as int,
  );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'content': content,
      'sender_name': senderName,
      "sender_id" : senderId ,
      "date" : date
    };
  }
}