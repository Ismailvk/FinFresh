part of 'todo_bloc.dart';

abstract class TodoState {}

abstract class TodoActionState extends TodoState {}

final class TodoInitial extends TodoState {}

class AddTodoSuccessMessageState extends TodoActionState {}

// ignore: must_be_immutable
class DataFetchSuccessState extends TodoState {
  List<TodoModel> todoList = [];

  DataFetchSuccessState({required this.todoList});
}

class AddTodoNavigationState extends TodoActionState {}

class LoadingFetchState extends TodoState {}

class UpdateTodoSuccessState extends TodoState {}

class ErrorFetchDataState extends TodoState {}
