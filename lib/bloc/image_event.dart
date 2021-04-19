part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class ImageLoadEvent extends ImageEvent {
//   final List<ImageModel> images;

//   const ImageLoadEvent(this.images);

//   @override
//   List<Object> get props => [images];

//   @override
//   String toString() => 'ImageLoaded { Image: $images }';
}

class ImageAddedEvent extends ImageEvent {
  final List<File> images;

  const ImageAddedEvent(this.images);

  @override
  List<Object> get props => [images];

  @override
  String toString() => 'ImageAdded { Image: $images }';
}

class ImageUpdatedEvent extends ImageEvent {
  final ImageModel image;

  const ImageUpdatedEvent(this.image);

  @override
  List<Object> get props => [image];

  @override
  String toString() => 'ImageUpdated { Image: $image }';
}

class ImageDeletedEvent extends ImageEvent {
  final List<ImageModel> images;

  const ImageDeletedEvent(this.images);

  @override
  List<Object> get props => [images];

  @override
  String toString() => 'ImageDeleted { Image: $images }';
}
