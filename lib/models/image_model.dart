import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  final String id;
  final String imagePath;
  final String imageUrl;

  ImageModel(this.id, this.imagePath, this.imageUrl);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'imageUrl': imageUrl,
    };
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      map['id'],
      map['imagePath'],
      map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageModel.fromJson(String source) =>
      ImageModel.fromMap(json.decode(source));

  static ImageModel fromSnapshot(DocumentSnapshot snap) {
    return ImageModel(
      snap.data()['id'],
      snap.data()['imagePath'],
      snap.data()['imageUrl'],
    );
  }

  @override
  List<Object> get props => [id, imagePath, imageUrl];
}
