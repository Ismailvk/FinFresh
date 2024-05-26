part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileImageClickEvent extends ProfileEvent {}

final class ProfileUpdateEvent extends ProfileEvent {
  final String imagePath;

  ProfileUpdateEvent({required this.imagePath});
}

final class FetchProfileData extends ProfileEvent {}
