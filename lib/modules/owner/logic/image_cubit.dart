import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bloc/bloc.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageInitial());

  Future<void> pickImage() async {
    List<XFile>? image;
    try {
      ImagePicker imagePicker = ImagePicker();
      image = await imagePicker.pickMultiImage(imageQuality: 50);
      print("Image is $image");

      for (XFile file in image) {
        File sizeFile = File(file.path);
        int sizeInBytes = sizeFile.readAsBytesSync().lengthInBytes;
        double kb = sizeInBytes / 1024;
        double mb = kb / 1024;
        print("MB is $mb");
        if (mb > 1) {
          emit(PickImageFailed(
              "Please pick image whose size is less than 1 MB"));
          // return;
        }
      }

      emit(ImagePicked(image));
    } catch (e) {
      emit(PickImageFailed(e.toString()));
    }
  }

  Future<void> cameraImage() async {
    List<XFile>? image = [];
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? cameImage =
          await imagePicker.pickImage(source: ImageSource.camera);
      if (cameImage != null) {
        image.add(cameImage);
      }

      emit(ImagePicked(image));
    } catch (e) {
      emit(PickImageFailed(e.toString()));
    }
  }
}
