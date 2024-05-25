import 'package:finfresh_test/controller/todo/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget alertdialog(BuildContext context, String id) => AlertDialog(
      title: const Text('Delete Student'),
      content: const Text('Are you sure you want to delete'),
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
            context.read<TodoBloc>().add(DeleteTodoSuccessEvent(id: id));
            context.read<TodoBloc>().add(FetchDataSuccessEvent());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
