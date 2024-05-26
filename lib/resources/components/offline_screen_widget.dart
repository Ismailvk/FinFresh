import 'package:finfresh_test/controller/local_storage/local_storage_bloc.dart';
import 'package:finfresh_test/model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineScreenWidget extends StatelessWidget {
  const OfflineScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocalStorageBloc, LocalStorageState>(
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
                              style: const TextStyle(color: Colors.white),
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
        });
  }
}
