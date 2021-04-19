import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static Future<File> getImageAsFile() async {
    final _imagePicker = ImagePicker();

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      PickedFile image =
          await _imagePicker.getImage(source: ImageSource.gallery);

      return File(image.path);
    } else {
      print("Permission not granted");
      return null;
    }
  }

  static showSnackbar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
        SnackBar(duration: Duration(seconds: 1), content: Text(text)));
  }
}
