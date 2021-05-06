part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageEmptyState extends ImageState {}

class ImageLoadSuccessState extends ImageState {
  final List<ImageModel> images;

  const ImageLoadSuccessState({this.images});

  @override
  List<Object> get props => [images];
}

class SelectedImageLoadSuccessState extends ImageState {
  final List<ImageModel> images;

  const SelectedImageLoadSuccessState({this.images});

  @override
  List<Object> get props => [images];
}

class ImageLoadingState extends ImageState {}

class ImageLoadFailedState extends ImageState {
  final String errorMessage;

  ImageLoadFailedState(this.errorMessage);
}
