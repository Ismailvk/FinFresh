import 'package:finfresh_test/controller/todo/todo_bloc.dart';
import 'package:finfresh_test/model/user_data.dart';
import 'package:finfresh_test/resources/components/button_widget.dart';
import 'package:finfresh_test/resources/components/textfield.dart';
import 'package:finfresh_test/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class EditScreen extends StatelessWidget {
  TodoModel todoObj;
  EditScreen({super.key, required this.todoObj});

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todoObj.title!;
    descriptionController.text = todoObj.description!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Screen'),
        centerTitle: true,
      ),
      body: BlocListener<TodoBloc, TodoState>(
        listenWhen: (previous, current) => current is TodoActionState,
        listener: (context, state) {},
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
              BlocListener<TodoBloc, TodoState>(
                listener: (context, state) {
                  if (state is UpdateTodoSuccessState) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                    context.read<TodoBloc>().add(FetchDataSuccessEvent());
                  }
                },
                child: ButtonWidget(
                    title: 'Update Data',
                    onPress: () => updateData(todoObj, context)),
              )
            ],
          ),
        ),
      ),
    );
  }

  updateData(TodoModel todoObject, BuildContext context) {
    final title = titleController.text;
    final description = descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      final todoObj =
          TodoModel(title: title, description: description, id: todoObject.id);
      context.read<TodoBloc>().add(UpdateTodoSuccessEvent(todoObj: todoObj));
    }
  }
}
