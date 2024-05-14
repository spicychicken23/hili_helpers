import 'package:cloud_firestore/cloud_firestore.dart';

class Promo {
  String Description;
  String ID;
  String Icon;
  String Name;
  String Title;
  Timestamp endTime;
  Timestamp startTime;
  String Shop_ID;

  Promo({
    required this.Description,
    required this.ID,
    required this.Icon,
    required this.Name,
    required this.Title,
    required this.endTime,
    required this.startTime,
    required this.Shop_ID,
  });

  Promo.fromJson(Map<String, Object?> json)
      : this(
          Description: json['Description']! as String,
          ID: json['ID']! as String,
          Icon: json['Icon']! as String,
          Name: json['Name']! as String,
          Title: json['Title']! as String,
          endTime: json['endTime']! as Timestamp,
          startTime: json['startTime']! as Timestamp,
          Shop_ID: json['Shop_ID']! as String,
        );

  Promo copyWith({
    String? Description,
    String? ID,
    String? Icon,
    String? Name,
    String? Title,
    Timestamp? endTime,
    Timestamp? startTime,
    String? Shop_ID,
  }) {
    return Promo(
      Description: Description ?? this.Description,
      ID: ID ?? this.ID,
      Icon: Icon ?? this.Icon,
      Name: Name ?? this.Name,
      Title: Title ?? this.Title,
      endTime: endTime ?? this.endTime,
      startTime: startTime ?? this.startTime,
      Shop_ID: Shop_ID ?? this.Shop_ID,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'Description': Description,
      'ID': ID,
      'Icon': Icon,
      'Name': Name,
      'Title': Title,
      'endTime': endTime,
      'startTime': startTime,
      'Shop_ID': Shop_ID,
    };
  }
}
