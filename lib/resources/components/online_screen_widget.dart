import 'package:finfresh_test/controller/todo/todo_bloc.dart';
import 'package:finfresh_test/resources/components/alert_dialog.dart';
import 'package:finfresh_test/view/edit_scree.dart';
import 'package:finfresh_test/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlineScreenWidget extends StatelessWidget {
  const OnlineScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      buildWhen: (previous, current) => current is! TodoActionState,
      listenWhen: (previous, current) => current is TodoActionState,
      listener: (context, state) {
        if (state is AddTodoSuccessMessageState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
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
                        color: const Color.fromARGB(255, 224, 222, 222),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 25,
                            child: Text(
                              number.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(data.title!),
                          subtitle: Text(data.description!),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditScreen(todoObj: data)));
                              } else if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alertdialog(context, data.id!);
                                  },
                                );
                              }
                            },
                            itemBuilder: (context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                  value: 'edit', child: Text('Edit')),
                              const PopupMenuItem<String>(
                                  value: 'delete', child: Text('Delete')),
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
    );
  }
}
