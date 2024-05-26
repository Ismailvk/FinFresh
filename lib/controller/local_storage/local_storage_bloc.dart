import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finfresh_test/data/database/local_database.dart';
import 'package:finfresh_test/model/user_data.dart';

part 'local_storage_event.dart';
part 'local_storage_state.dart';

class LocalStorageBloc extends Bloc<LocalStorageEvent, LocalStorageState> {
  LocalStorageBloc() : super(LocalStorageInitial()) {
    on<StoreDataToDatabas>(storeToDatabase);
    on<GetDataFromDatabase>(getDataFromDatabase);
  }

  FutureOr<void> storeToDatabase(
      StoreDataToDatabas event, Emitter<LocalStorageState> emit) async {
    try {
      await DatabaseHelper.instance.insertTodos(event.todoList);
    } catch (e) {
      print(e);
    }
  }

  FutureOr<void> getDataFromDatabase(
      GetDataFromDatabase event, Emitter<LocalStorageState> emit) async {
    try {
      List<TodoModel> todoList = await DatabaseHelper.instance.getAllTodos();
      emit(GetLocalStorageDataSuccessState(todoList: todoList));
    } catch (e) {
      emit(LocaStorageDataFailedState());
    }
  }
}
