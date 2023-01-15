
class RoomModel {
  String roomId ;
  String titleRoom ;
  String descriptionRoom ;
  String categoryId ;

  RoomModel({
 required this.roomId , required this.titleRoom , required this.descriptionRoom , required this.categoryId});

  RoomModel.fromJson(Map<String, Object?> json)
      : this(

    titleRoom: json['title_room']! as String,
    descriptionRoom: json['description_room']! as String,
    categoryId: json['category_model']! as String,
    roomId: json['room_id']! as String,
  );

  Map<String, Object?> toJson() {
    return {

      'title_room': titleRoom,
      'description_room': descriptionRoom,
      'category_model': categoryId,
      "room_id" : roomId
    };
  }

}
