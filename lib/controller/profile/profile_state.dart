part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileImagePickState extends ProfileState {
  File image;
  ProfileImagePickState({required this.image});
}

final class ProfileUpdateFailedState extends ProfileState {}

final class ProfileUpdateSuccessState extends ProfileState {}

final class FetchProfileDataState extends ProfileState {
  final String imagePath;

  FetchProfileDataState({required this.imagePath});
}
