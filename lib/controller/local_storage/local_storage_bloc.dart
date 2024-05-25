import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finfresh_test/model/user_data.dart';

part 'local_storage_event.dart';
part 'local_storage_state.dart';

class LocalStorageBloc extends Bloc<LocalStorageEvent, LocalStorageState> {
  LocalStorageBloc() : super(LocalStorageInitial()) {
    on<StoreDataToDatabas>(storeToDatabase);
  }

  FutureOr<void> storeToDatabase(
      StoreDataToDatabas event, Emitter<LocalStorageState> emit) {}
}
