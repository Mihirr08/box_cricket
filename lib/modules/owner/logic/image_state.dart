part of 'image_cubit.dart';

@immutable
abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImagePicked extends ImageState {
  final List<XFile>? image;

  ImagePicked(this.image);
}

class PickImageFailed extends ImageState {
  final String? error;

  PickImageFailed(this.error);
}
