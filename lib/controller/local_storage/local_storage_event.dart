part of 'local_storage_bloc.dart';

sealed class LocalStorageEvent {}

final class StoreDataToDatabas extends LocalStorageEvent {
  List<TodoModel> todoList;

  StoreDataToDatabas({required this.todoList});
}

final class GetDataFromDatabase extends LocalStorageEvent {}
