part of 'todo_bloc.dart';

abstract class TodoEvent {}

class FetchDataSuccessEvent extends TodoEvent {}

class AddTodoSuccessEvent extends TodoEvent {
  final TodoModel todoObj;
  final BuildContext context;
  AddTodoSuccessEvent({required this.todoObj, required this.context});
}

class UpdateTodoSuccessEvent extends TodoEvent {
  final TodoModel todoObj;
  UpdateTodoSuccessEvent({required this.todoObj});
}

class DeleteTodoSuccessEvent extends TodoEvent {
  final String id;
  DeleteTodoSuccessEvent({required this.id});
}
