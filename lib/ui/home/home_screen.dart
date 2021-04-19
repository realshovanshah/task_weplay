import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weplay/bloc/image_bloc.dart';
import 'package:task_weplay/models/image_model.dart';
import 'package:task_weplay/services/auth_service.dart';
import 'package:task_weplay/services/image_service.dart';
import 'package:task_weplay/ui/upload/upload_screen.dart';
import 'package:task_weplay/utilities/utils.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.firebaseAuth}) : super(key: key);

  final FirebaseAuth firebaseAuth;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imageUrl;
  final _imageService = ImageService();
  List<int> _selectedItems = List<int>();
  List<ImageModel> _selectedImageList = List<ImageModel>();
  var _isOptionsVisible = true;

  @override
  void initState() {
    BlocProvider.of<ImageBloc>(context).add(ImageLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<ImageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService(FirebaseAuth.instance).signOut();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
            stream: widget.firebaseAuth.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active)
                return LinearProgressIndicator();
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, bottom: 8),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Long press to select images.",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 500, minHeight: 500),
                    child: CustomScrollView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      slivers: [
                        BlocBuilder<ImageBloc, ImageState>(
                          builder: (context, state) {
                            if (state is ImageLoadFailedState) {
                              return SliverToBoxAdapter(
                                child: Center(
                                    child:
                                        Text("An unexpected error occurred")),
                              );
                            }
                            if (state is ImageLoadSuccessState) {
                              return StreamBuilder(
                                  stream: state.images,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            return ImageListItem(
                                              imageModel: snapshot.data[index],
                                              selectedItems: _selectedItems,
                                              selectedImageList:
                                                  _selectedImageList,
                                              index: index,
                                            );
                                          },
                                          childCount: snapshot.data.length,
                                        ),
                                      );
                                    } else {
                                      return SliverToBoxAdapter(
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text("No data found"),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              LinearProgressIndicator()
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  });
                            } else {
                              Center(child: CircularProgressIndicator());
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      FlatButton(
                          onPressed: () {
                            if (_selectedItems.isEmpty) {
                              return Utils.showSnackbar(
                                  context, "No image is selected.");
                            } else {
                              setState(() {
                                _selectedItems.clear();
                                _selectedImageList.clear();
                              });
                            }
                          },
                          textColor: Colors.blue,
                          child: Text('Cancel')),
                      FlatButton(
                          onPressed: () {
                            if (_selectedItems.isEmpty) {
                              return Utils.showSnackbar(
                                  context, "No image is selected.");
                            } else {
                              _bloc.add(ImageDeletedEvent(_selectedImageList));

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<ImageBloc>(context),
                                  child: UploadScreen(
                                    text: "Choose images to update with.",
                                  ),
                                ),
                              ));

                              //not being deleted from firestore if when using this
                              // setState(() {
                              //   _selectedItems.clear();
                              //   _selectedImageList.clear();
                              // });
                            }
                          },
                          textColor: Colors.blue,
                          child: Text('Update')),
                      RaisedButton(
                          onPressed: () {
                            print("Count is: ${_selectedImageList.length}");
                            _bloc.add(ImageDeletedEvent(_selectedImageList));
                            // _selectedItems.clear();
                            // _selectedImageList.clear();
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text('Delete')),
                      SizedBox(width: 20)
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, top: 12.0, bottom: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Upload Image',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<ImageBloc>(context),
                            child: UploadScreen(
                              text: "Add Images",
                            ),
                          ),
                        ));
                      },
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}

class ImageListItem extends StatefulWidget {
  const ImageListItem({
    Key key,
    @required List<int> selectedItems,
    @required this.index,
    this.imageModel,
    this.selectedImageList,
  })  : _selectedItems = selectedItems,
        super(key: key);

  final List<int> _selectedItems;
  final List<ImageModel> selectedImageList;
  final int index;
  final ImageModel imageModel;

  @override
  _ImageListItemState createState() => _ImageListItemState();
}

class _ImageListItemState extends State<ImageListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (widget._selectedItems.contains(widget.index)) {
          setState(() {
            widget._selectedItems.removeWhere((val) => val == widget.index);
            widget.selectedImageList.remove(widget.imageModel);
          });
        }
      },
      onLongPress: () {
        if (!widget._selectedItems.contains(widget.index)) {
          setState(() {
            widget._selectedItems.add(widget.index);
            widget.selectedImageList.add(widget.imageModel);
          });
        }
      },
      title: Container(
        alignment: Alignment.center,
        height: 150,
        color: (widget._selectedItems.contains(widget.index))
            ? Colors.blue.withOpacity(0.7)
            : Colors.blue.withOpacity(0.2),
        child: ListTile(
          leading: (widget.imageModel.imageUrl == null)
              ? FlutterLogo(
                  size: 100,
                )
              : Image.network(widget.imageModel.imageUrl,
                  height: 100, width: 100, fit: BoxFit.cover),
          subtitle: Text(widget.imageModel.id),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 1, top: 6),
            child: Text(
              "${widget.index}",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
