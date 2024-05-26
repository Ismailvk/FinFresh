import 'dart:async';
import 'dart:io';
import 'package:finfresh_test/data/shared_preference/shared_preference.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileImageClickEvent>(profileImagePick);
    on<ProfileUpdateEvent>(profileUpdate);
    on<FetchProfileData>(fetchProfileData);
  }

  FutureOr<void> profileImagePick(
      ProfileImageClickEvent event, Emitter<ProfileState> emit) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 12),
          compressQuality: 90,
          compressFormat: ImageCompressFormat.jpg);
      if (croppedFile == null) return null;
      File pickedImage = File(croppedFile.path);
      emit(ProfileImagePickState(image: pickedImage));
    } else {
      emit(ProfileUpdateFailedState());
    }
  }

  FutureOr<void> profileUpdate(
      ProfileUpdateEvent event, Emitter<ProfileState> emit) async {
    try {
      SharedPref.instance.storeNameAndImagePath(event.imagePath);
      emit(ProfileUpdateSuccessState());
    } catch (e) {
      print(e);
    }
  }

  FutureOr<void> fetchProfileData(
      FetchProfileData event, Emitter<ProfileState> emit) {
    try {
      Map<String, String?> data = SharedPref.instance.getNameAndImagePath();
      print('data is ${data.keys}');
      if (data.values.isNotEmpty) {
        emit(FetchProfileDataState(imagePath: data['imagePath']!));
      }
    } catch (e) {
      print(e);
    }
  }
}
