import 'package:finfresh_test/controller/todo/todo_bloc.dart';
import 'package:finfresh_test/model/user_data.dart';
import 'package:finfresh_test/resources/components/button_widget.dart';
import 'package:finfresh_test/resources/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class AddStudentScreen extends StatelessWidget {
  AddStudentScreen({super.key});

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        centerTitle: true,
      ),
      body: BlocListener<TodoBloc, TodoState>(
        listenWhen: (previous, current) => current is TodoActionState,
        listener: (context, state) {
          if (state is AddTodoSuccessMessageState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Todo Added')));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextfieldWidget(
                  controller: titleController, hintText: 'Add Your Title'),
              const SizedBox(height: 20),
              TextfieldWidget(
                  controller: descriptionController,
                  hintText: 'Add Your Description'),
              const SizedBox(height: 20),
              ButtonWidget(title: 'Add Todo', onPress: () => addTodo(context))
            ],
          ),
        ),
      ),
    );
  }

  void addTodo(BuildContext context) {
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty) {
      final title = titleController.text;
      final description = descriptionController.text;
      TodoModel todoObj = TodoModel(title: title, description: description);

      context.read<TodoBloc>().add(AddTodoSuccessEvent(todoObj: todoObj));
      context.read<TodoBloc>().add(FetchDataSuccessEvent());
    }
  }
}
