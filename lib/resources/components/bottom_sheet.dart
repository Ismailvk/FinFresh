import 'dart:io';
import 'package:finfresh_test/controller/profile/profile_bloc.dart';
import 'package:finfresh_test/controller/theme/theme_bloc.dart';
import 'package:finfresh_test/resources/components/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

File? image;

void bottomSheet(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: Colors.white,
          height: 300,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Switch(
                          value:
                              context.read<ThemeBloc>().state == ThemeMode.dark,
                          onChanged: (value) {
                            context.read<ThemeBloc>().add(ThemeChanged(value));
                          },
                        ),
                        const Text('Light / Dark')
                      ],
                    ),
                  ],
                ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileImagePickState) {
                      image = state.image;
                      return GestureDetector(
                          onTap: () {
                            context
                                .read<ProfileBloc>()
                                .add(ProfileImageClickEvent());
                          },
                          child: ClipOval(
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.file(
                                File(state.image.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ));
                    } else if (state is ProfileUpdateSuccessState) {
                      context.read<ProfileBloc>().add(FetchProfileData());
                    }
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileImageClickEvent());
                      },
                      child: const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.add_photo_alternate, size: 35),
                      ),
                    );
                  },
                ),
                ButtonWidget(
                  title: 'Update',
                  onPress: () {
                    if (image?.path != null) {
                      context.read<ProfileBloc>().add(
                            ProfileUpdateEvent(
                              imagePath: image!.path,
                            ),
                          );
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
