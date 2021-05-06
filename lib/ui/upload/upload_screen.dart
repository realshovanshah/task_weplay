import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_weplay/bloc/image_bloc.dart';
import 'package:task_weplay/bloc/navigation_bloc.dart';
import 'package:task_weplay/models/image_model.dart';
import 'package:task_weplay/utilities/utils.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({Key key, this.text}) : super(key: key);
  final String text;

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool uploading = false;
  final picker = ImagePicker();
  Map<int, File> _images = {};

  @override
  void initState() {
    print('inited');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        final imageBloc = BlocProvider.of<ImageBloc>(context);

        String text;
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.text),
              actions: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        uploading = true;
                      });
                      (widget.text == 'Add Images')
                          ? imageBloc.add(ImageAddedEvent(_images.values))
                          : imageBloc.add(ImageUpdatedEvent(
                              List.from(
                                _images.values,
                              ),
                              ModalRoute.of(context).settings.arguments
                                  as List<String>));
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
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: BlocBuilder<NavigationBloc, ImageState>(
                    builder: (context, state) {
                      if (state is ImageEmptyState) {
                        return LinearProgressIndicator();
                      }
                      if (state is SelectedImageLoadSuccessState) {
                        return Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.images.length,
                            itemBuilder: (_, int index) {
                              return imageViewBuilder(
                                  index, state.images[index]);
                            },
                            shrinkWrap: true,
                          ),
                        );
                      } else {
                        return Text("Failed to load images");
                      }
                    },
                  ),
                ),
                uploading ? ProgressBarWidget() : Container(),
              ],
            ));
      },
    );
  }

  Widget imageViewBuilder(int index, ImageModel imageModel) {
    print("ramm" + imageModel.clicked.toString());
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 100,
            width: 100,
            child: (imageModel.clicked == false)
                ? Image.network(
                    imageModel.imageUrl,
                    fit: BoxFit.fill,

                    // loadingBuilder: (context, child, loadingProgress) =>
                    //     Center(child: Text("Loading")),
                  )
                : Image(image: FileImage(_images[index])),
          ),
        ),
        Positioned(
          top: 20,
          left: 30,
          child: IconButton(
              color: Colors.lightBlueAccent,
              icon: Icon(
                Icons.add,
                size: 42,
              ),
              onPressed: () =>
                  !uploading ? chooseImage(imageModel, index) : null),
        )
      ],
    );
  }

  chooseImage(ImageModel imageModel, int index) async {
    await Permission.storage.request();

    var permissionStatus = await Permission.storage.status;

    if (permissionStatus.isGranted) {
      print(permissionStatus.isGranted);
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      final pickedImage = File(pickedFile.path);
      setState(() {
        _images[index] = pickedImage;
        imageModel.clicked = true;
        print(_images);
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
