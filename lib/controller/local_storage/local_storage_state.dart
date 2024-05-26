part of 'local_storage_bloc.dart';

sealed class LocalStorageState {}

final class LocalStorageInitial extends LocalStorageState {}

final class LocaStorageDataFailedState extends LocalStorageState {}

final class GetLocalStorageDataSuccessState extends LocalStorageState {
  List<TodoModel> todoList;

  GetLocalStorageDataSuccessState({required this.todoList});
}
