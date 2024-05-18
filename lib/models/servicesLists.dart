// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

class fnb {
  String ID;
  String Name;
  String Owner;
  String Category;
  double Rating;
  int Raters;
  int Rate_1;
  int Rate_2;
  int Rate_3;
  int Rate_4;
  int Rate_5;
  String Icon;
  bool open;
  fnb({
    required this.ID,
    required this.Name,
    required this.Owner,
    required this.Category,
    required this.Rating,
    required this.Raters,
    required this.Rate_1,
    required this.Rate_2,
    required this.Rate_3,
    required this.Rate_4,
    required this.Rate_5,
    required this.Icon,
    required this.open,
  });

  fnb.fromJson(Map<String, Object?> json)
      : this(
          ID: json['ID']! as String,
          Name: json['Name']! as String,
          Owner: json['Owner']! as String,
          Category: json['Category']! as String,
          Rating: json['Rating']! as double,
          Raters: json['Raters'] as int,
          Rate_1: json['Rate_1'] as int,
          Rate_2: json['Rate_2'] as int,
          Rate_3: json['Rate_3'] as int,
          Rate_4: json['Rate_4'] as int,
          Rate_5: json['Rate_5'] as int,
          Icon: json['Icon'] as String,
          open: json['open'] as bool,
        );

  fnb copyWith({
    String? ID,
    String? Name,
    String? Owner,
    String? Category,
    double? Rating,
    int? Raters,
    int? Rate_1,
    int? Rate_2,
    int? Rate_3,
    int? Rate_4,
    int? Rate_5,
    String? Icon,
    bool? open,
  }) {
    return fnb(
      ID: ID ?? this.ID,
      Name: Name ?? this.Name,
      Owner: Owner ?? this.Owner,
      Category: Category ?? this.Category,
      Rating: Rating ?? this.Rating,
      Raters: Raters ?? this.Raters,
      Rate_1: Rate_1 ?? this.Rate_1,
      Rate_2: Rate_2 ?? this.Rate_2,
      Rate_3: Rate_3 ?? this.Rate_3,
      Rate_4: Rate_4 ?? this.Rate_4,
      Rate_5: Rate_5 ?? this.Rate_5,
      Icon: Icon ?? this.Icon,
      open: open ?? this.open,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'ID': ID,
      'Name': Name,
      'Owner': Owner,
      'Category': Category,
      'Rating': Rating,
      'Raters': Raters,
      'Rate_1': Rate_1,
      'Rate_2': Rate_2,
      'Rate_3': Rate_3,
      'Rate_4': Rate_4,
      'Rate_5': Rate_5,
      'Icon': Icon,
      'open': open
    };
  }
}
