import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:task_weplay/models/image_model.dart';
import 'package:task_weplay/utilities/constants.dart';

class ImageService {
  final _storageSnapshot =
      FirebaseStorage.instance.ref().child(kFirebaseStorageFolder);

  final _db = FirebaseFirestore.instance;

  Future<void> uploadImages(List<File> files) async {
    print("called upload");
    try {
      if (files != null) {
        var batch = _db.batch();
        for (var i = 0; i < files.length; i++) {
          var fileName = files[i].hashCode.toString();
          var snapshot =
              await _storageSnapshot.child(fileName).putFile(files[i]);

          await snapshot.ref.getDownloadURL().then(
            (value) async {
              var imageRef = _db.collection("images").doc(fileName);
              var imageModel = ImageModel(fileName, files[i].path, value);
              batch.set(imageRef, imageModel.toMap());

              return;
            },
            onError: (e) => print("Error" + e.toString()),
          );
        }
        batch.commit().then((value) => debugPrint("Batch upload success"));
      } else {
        debugPrint("No image found");
      }
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> updateImages(List<File> files, List<String> imageId) async {
    print("called update");
    try {
      if (files != null) {
        var batch = _db.batch();
        for (var i = 0; i < files.length; i++) {
          var fileName = imageId[i];
          var snapshot =
              await _storageSnapshot.child(fileName).putFile(files[i]);

          await snapshot.ref.getDownloadURL().then(
            (value) async {
              var imageRef = _db.collection("images").doc(fileName);
              var imageModel = ImageModel(fileName, files[i].path, value);
              batch.update(imageRef, imageModel.toMap());

              return;
            },
            onError: (e) => print("Error" + e.toString()),
          );
        }
        batch.commit().then((value) => debugPrint("Batch update success"));
      } else {
        debugPrint("No image found");
      }
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> deleteImage(List<ImageModel> images) async {
    print("called delete");
    try {
      if (images != null) {
        var batch = _db.batch();
        for (var i = 0; i < images.length; i++) {
          var currentImage = images[i];
          await _storageSnapshot.child(currentImage.id).delete().then(
            (value) async {
              var imageRef = _db.collection("images").doc(currentImage.id);
              batch.delete(imageRef);

              return;
            },
            onError: (e) => print("Error" + e.toString()),
          );
        }
        batch.commit().then((value) => debugPrint("Batch delete success"));
      } else {
        debugPrint("No image found");
      }
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  Stream<List<ImageModel>> getImages() {
    return _db.collection("images").snapshots().map((snapshots) {
      return snapshots.docs.map(
        (doc) {
          print(doc.data().values);
          return ImageModel.fromSnapshot(doc);
        },
      ).toList();
    });
  }
}
