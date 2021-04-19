import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_weplay/bloc/image_bloc.dart';
import 'package:task_weplay/utilities/utils.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({Key key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool uploading = false;
  final picker = ImagePicker();
  List<File> _images = [];
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        final imageBloc = BlocProvider.of<ImageBloc>(context);
        return Scaffold(
            appBar: AppBar(
              title: Text('Add Image'),
              actions: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        uploading = true;
                      });
                      imageBloc.add(ImageAddedEvent(_images));
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Upload',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ))
              ],
            ),
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  child: GridView.builder(
                      itemCount: _images.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Container(
                                margin: EdgeInsets.all(8),
                                color: Colors.blueAccent,
                                child: Center(
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      return IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () => !uploading
                                              ? chooseImage()
                                              : null);
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_images[index - 1]),
                                        fit: BoxFit.cover)),
                              );
                      }),
                ),
                uploading ? ProgressBarWidget() : Container(),
              ],
            ));
      },
    );
  }

  chooseImage() async {
    await Permission.storage.request();

    var permissionStatus = await Permission.storage.status;

    if (permissionStatus.isGranted) {
      print(permissionStatus.isGranted);
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        _images.add(File(pickedFile?.path));
      });
    } else {
      print("not granted permissions");
    }
  }
}

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 16,
          ),
          Text(" Uploading..."),
        ],
      )),
    );
  }
}
