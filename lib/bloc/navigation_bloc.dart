import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weplay/bloc/image_bloc.dart';
import 'package:task_weplay/services/image_service.dart';

class NavigationBloc extends Bloc<ImageEvent, ImageState> {
  final ImageService _imageService;

  NavigationBloc(this._imageService) : super(ImageEmptyState());

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is ImageUploadScreenNavigatedEvent) {
      yield* _mapUploadScreenNavigatedToState(event);
    }
  }

  Stream<ImageState> _mapUploadScreenNavigatedToState(
      ImageUploadScreenNavigatedEvent event) async* {
    print("called this");
    yield SelectedImageLoadSuccessState(images: event.images);
  }
}
