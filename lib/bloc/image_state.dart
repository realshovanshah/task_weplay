part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageLoadSuccessState extends ImageState {
  final Stream<List<ImageModel>> images;

  const ImageLoadSuccessState([this.images = const Stream.empty()]);

  @override
  List<Object> get props => [images];
}

class ImageLoadingState extends ImageState {}

class ImageLoadFailedState extends ImageState {}
