import 'package:finfresh_test/controller/bloc/todo_bloc.dart';
import 'package:finfresh_test/view/add_screen.dart';
import 'package:finfresh_test/view/edit_scree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<TodoBloc>().add(FetchDataSuccessEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        centerTitle: true,
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        buildWhen: (previous, current) => current is! TodoActionState,
        listenWhen: (previous, current) => current is TodoActionState,
        listener: (context, state) {
          if (state is AddTodoSuccessMessageState) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
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
                                      return AlertDialog(
                                        title: const Text('Delete Student'),
                                        content: const Text(
                                            'Are you sure you want to delete'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Delete'),
                                            onPressed: () {
                                              context.read<TodoBloc>().add(
                                                  DeleteTodoSuccessEvent(
                                                      id: data.id!));
                                              context
                                                  .read<TodoBloc>()
                                                  .add(FetchDataSuccessEvent());
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
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
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddStudentScreen()));
          },
          label: const Text('Add Studnet')),
    );
  }
}
