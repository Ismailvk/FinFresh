import 'dart:async';
import 'package:finfresh_test/controller/local_storage/local_storage_bloc.dart';
import 'package:finfresh_test/controller/profile/profile_bloc.dart';
import 'package:finfresh_test/controller/todo/todo_bloc.dart';
import 'package:finfresh_test/resources/components/bottom_sheet.dart';
import 'package:finfresh_test/resources/components/circle_widget.dart';
import 'package:finfresh_test/resources/components/offline_screen_widget.dart';
import 'package:finfresh_test/resources/components/online_screen_widget.dart';
import 'package:finfresh_test/utils/notifications.dart';
import 'package:finfresh_test/view/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  bool isOnline = false;
  StreamSubscription? isOnlineConnected;
  Notificationservices notification = Notificationservices();

  @override
  void initState() {
    notification.initializationNotifications();
    isOnlineConnected = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() => isOnline = true);
          dataCheck(context);
          break;
        case InternetStatus.disconnected:
          setState(() => isOnline = false);
          dataCheck(context);
          break;
        default:
          setState(() => isOnline = false);
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todo App'),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                bottomSheet(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is FetchProfileDataState) {
                      return CircleWidget(imagePath: state.imagePath);
                    }
                    return const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.add_photo_alternate),
                    );
                  },
                ),
              ),
            )
          ],
        ),
        body:
            isOnline ? const OnlineScreenWidget() : const OfflineScreenWidget(),
        floatingActionButton: isOnline
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddStudentScreen(),
                    ),
                  );
                },
                label: const Text('Add Studnet'))
            : const SizedBox.shrink());
  }

  dataCheck(BuildContext context) {
    if (isOnline) {
      notification.sendNotification('Online', 'You are online');
      context.read<TodoBloc>().add(FetchDataSuccessEvent());
      context.read<ProfileBloc>().add(FetchProfileData());
    } else {
      notification.sendNotification('Network Error', 'You are offline');
      context.read<LocalStorageBloc>().add(GetDataFromDatabase());
      context.read<ProfileBloc>().add(FetchProfileData());
    }
  }
}
