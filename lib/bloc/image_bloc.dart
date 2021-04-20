import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weplay/models/image_model.dart';
import 'package:task_weplay/services/image_service.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageService _imageService;
  ImageBloc(this._imageService) : super(ImageLoadingState());

  @override
  Stream<ImageState> mapEventToState(
    ImageEvent event,
  ) async* {
    if (event is ImageDeletedEvent) {
      yield* _mapDeleteImageToState(event);
    }
    if (event is ImageAddedEvent) {
      yield* _mapUploadImageToState(event);
    }
    if (event is ImageLoadEvent) {
      yield* _mapLoadImageToState(event);
    }
    if (event is ImageUpdatedEvent) {
      yield* _mapUpdateImageToState(event);
    }
  }

  Stream<ImageState> _mapDeleteImageToState(ImageDeletedEvent event) async* {
    _imageService.deleteImage(event.images);
  }

  Stream<ImageState> _mapUploadImageToState(ImageAddedEvent event) async* {
    _imageService.uploadImages(event.images);
  }

  Stream<ImageState> _mapLoadImageToState(ImageLoadEvent event) async* {
    print("called this");
    yield ImageLoadSuccessState(_imageService.getImages());
  }

  Stream<ImageState> _mapUpdateImageToState(ImageUpdatedEvent event) async* {
    print("called this");
    _imageService.updateImages(event.images, event.ids);
  }
}
