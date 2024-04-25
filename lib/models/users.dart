// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

class users {
  String? UID;
  String? address;
  String? user_id;
  Timestamp? birthdate;
  String? gender;
  String? name;
  String? ph_no;
  users({
    this.UID,
    this.address,
    this.user_id,
    this.birthdate,
    this.gender,
    this.name,
    this.ph_no,
  });

  users.fromJson(Map<String, Object?> json)
      : this(
          UID: json['UID']! as String,
          address: json['address']! as String,
          user_id: json['user_id']! as String,
          birthdate: json['birthdate']! as Timestamp,
          gender: json['gender']! as String,
          name: json['name']! as String,
          ph_no: json['ph_no']! as String,
        );

  users copyWith({
    String? UID,
    String? address,
    String? user_id,
    Timestamp? birthdate,
    String? gender,
    String? name,
    String? ph_no,
  }) {
    return users(
        UID: UID ?? this.UID,
        address: address ?? this.address,
        user_id: user_id ?? this.user_id,
        birthdate: birthdate ?? this.birthdate,
        gender: gender ?? this.gender,
        name: name ?? this.name,
        ph_no: ph_no ?? this.ph_no);
  }

  Map<String, dynamic> toJson() {
    return {
      'UID': UID,
      'address': address,
      'user_id': user_id,
      'birthdate': birthdate,
      'gender': gender,
      'name': name,
      'ph_no': ph_no,
    };
  }
}
