// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

class fnb {
  String ID;
  String Name;
  String Owner;
  String Category;
  double Rating;

  fnb({
    required this.ID,
    required this.Name,
    required this.Owner,
    required this.Category,
    required this.Rating,
  });

  fnb.fromJson(Map<String, Object?> json)
      : this(
          ID: json['ID']! as String,
          Name: json['Name']! as String,
          Owner: json['Owner']! as String,
          Category: json['Category']! as String,
          Rating: json['Rating']! as double,
        );

  fnb copyWith({
    String? ID,
    String? Name,
    String? Owner,
    String? Category,
    double? Rating,
  }) {
    return fnb(
      ID: ID ?? this.ID,
      Name: Name ?? this.Name,
      Owner: Owner ?? this.Owner,
      Category: Category ?? this.Category,
      Rating: Rating ?? this.Rating,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'ID': ID,
      'Name': Name,
      'Owner': Owner,
      'Category': Category,
      'Rating': Rating,
    };
  }
}
