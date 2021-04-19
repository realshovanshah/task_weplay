import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:task_weplay/models/image_model.dart';
import 'package:task_weplay/utilities/constants.dart';
import 'package:task_weplay/utilities/utils.dart';

class ImageService {
  final _storageSnapshot =
      FirebaseStorage.instance.ref().child(kFirebaseStorageFolder);

  final _db = FirebaseFirestore.instance;

  Future<void> uploadImages(List<File> files) async {
    print("called upload");
    try {
      if (files != null) {
        for (var i = 0; i < files.length; i++) {
          var fileName = files[i].hashCode.toString();
          var snapshot =
              await _storageSnapshot.child(fileName).putFile(files[i]);

          await snapshot.ref.getDownloadURL().then(
            (value) async {
              var batch = _db.batch();
              var imageRef = _db.collection("images").doc(fileName);
              var imageModel = ImageModel(fileName, files[i].path, value);
              batch.set(imageRef, imageModel.toMap());
              batch
                  .commit()
                  .then((value) => debugPrint("Batch upload success"));
              return;
            },
            onError: (e) => print("Error" + e.toString()),
          );
        }
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
        for (var i = 0; i < images.length; i++) {
          var currentImage = images[i];
          await _storageSnapshot.child(currentImage.id).delete().then(
            (value) async {
              var batch = _db.batch();

              var imageRef = _db.collection("images").doc(currentImage.id);
              batch.delete(imageRef);
              batch
                  .commit()
                  .then((value) => debugPrint("Batch delete success"));
              return;
            },
            onError: (e) => print("Error" + e.toString()),
          );
        }
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
