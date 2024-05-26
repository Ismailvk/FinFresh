import 'dart:async';
import 'package:finfresh_test/controller/local_storage/local_storage_bloc.dart';
import 'package:finfresh_test/controller/todo/todo_bloc.dart';
import 'package:finfresh_test/model/user_data.dart';
import 'package:finfresh_test/resources/components/alert_dialog.dart';
import 'package:finfresh_test/utils/notifications.dart';
import 'package:finfresh_test/view/add_screen.dart';
import 'package:finfresh_test/view/edit_scree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        ),
        body: isOnline
            ? BlocConsumer<TodoBloc, TodoState>(
                buildWhen: (previous, current) => current is! TodoActionState,
                listenWhen: (previous, current) => current is TodoActionState,
                listener: (context, state) {
                  if (state is AddTodoSuccessMessageState) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                  }
                },
                builder: (context, state) {
                  if (state is DataFetchSuccessState) {
                    return state.todoList.isNotEmpty
                        ? ListView.builder(
                            itemCount: state.todoList.length,
                            itemBuilder: (context, index) {
                              final data = state.todoList[index];
                              final number = index + 1;
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: Card(
                                  color:
                                      const Color.fromARGB(255, 224, 222, 222),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 25,
                                      child: Text(
                                        number.toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    title: Text(data.title!),
                                    subtitle: Text(data.description!),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditScreen(
                                                          todoObj: data)));
                                        } else if (value == 'delete') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alertdialog(
                                                  context, data.id!);
                                            },
                                          );
                                        }
                                      },
                                      itemBuilder: (context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('No Data Found'));
                  }
                  if (state is LoadingFetchState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ErrorFetchDataState) {
                    return const Center(child: Text('No Data Found'));
                  }
                  return const SizedBox.shrink();
                },
              )
            : BlocConsumer<LocalStorageBloc, LocalStorageState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is GetLocalStorageDataSuccessState) {
                    return Column(
                      children: [
                        Container(
                          height: 40,
                          width: double.infinity,
                          color: Colors.red,
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Check Your Internet Connection'),
                                Icon(Icons.refresh)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: state.todoList.length,
                              itemBuilder: (context, index) {
                                TodoModel item = state.todoList[index];
                                final number = index + 1;
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 25,
                                    child: Text(
                                      number.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(item.title!),
                                  subtitle: Text(item.description!),
                                );
                              }),
                        ),
                      ],
                    );
                  } else if (state is LocaStorageDataFailedState) {
                    return const Center(
                      child: Text('Something Went Wrong'),
                    );
                  }
                  return const SizedBox.shrink();
                }),
        floatingActionButton: isOnline
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddStudentScreen()));
                },
                label: const Text('Add Studnet'))
            : const SizedBox.shrink());
  }

  dataCheck(BuildContext context) {
    if (isOnline) {
      notification.sendNotification('Online', 'You are online');
      context.read<TodoBloc>().add(FetchDataSuccessEvent());
    } else {
      notification.sendNotification('Network Error', 'You are offline');
      context.read<LocalStorageBloc>().add(GetDataFromDatabase());
    }
  }
}
