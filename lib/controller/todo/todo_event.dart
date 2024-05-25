part of 'todo_bloc.dart';

abstract class TodoEvent {}

class FetchDataSuccessEvent extends TodoEvent {}

class AddTodoSuccessEvent extends TodoEvent {
  final TodoModel todoObj;
  AddTodoSuccessEvent({required this.todoObj});
}

class UpdateTodoSuccessEvent extends TodoEvent {
  final TodoModel todoObj;
  UpdateTodoSuccessEvent({required this.todoObj});
}

class DeleteTodoSuccessEvent extends TodoEvent {
  final String id;
  DeleteTodoSuccessEvent({required this.id});
}
