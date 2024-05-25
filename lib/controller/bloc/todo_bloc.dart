import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:finfresh_test/data/ntwork/api_urls.dart';
import 'package:finfresh_test/model/user_data.dart';
import 'package:http/http.dart' as http;
part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<AddTodoSuccessEvent>(addTodoEvent);
    on<FetchDataSuccessEvent>(fetchTodoData);
    on<DeleteTodoSuccessEvent>(deleteTodo);
    on<UpdateTodoSuccessEvent>(updateTodoEvent);
  }
  final header = {'Content-Type': 'application/json'};

  FutureOr<void> addTodoEvent(
      AddTodoSuccessEvent event, Emitter<TodoState> emit) async {
    final uri = Uri.parse(ApiUrls.addData);
    TodoModel todoObj = event.todoObj;
    final data = TodoModel.toJson(todoObj);
    final body = jsonEncode(data);
    final response = await http.post(uri, body: body, headers: header);
    if (response.statusCode == 201) {
      emit(AddTodoSuccessMessageState());
    } else {
      // emit()
    }
  }

  FutureOr<void> fetchTodoData(
      FetchDataSuccessEvent event, Emitter<TodoState> emit) async {
    emit(LoadingFetchState());
    List<TodoModel> todoListData = [];
    final uri = Uri.parse(ApiUrls.fetchData);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body)['items'] as List;
      todoListData = body.map((e) => TodoModel.fromJson(e)).toList();
      emit(DataFetchSuccessState(todoList: todoListData));
    } else {
      emit(ErrorFetchDataState());
    }
  }

  FutureOr<void> deleteTodo(
      DeleteTodoSuccessEvent event, Emitter<TodoState> emit) async {
    final url = '${ApiUrls.deleteData}/${event.id}';
    final uri = Uri.parse(url);
    await http.delete(uri, headers: header);
  }

  FutureOr<void> updateTodoEvent(
      UpdateTodoSuccessEvent event, Emitter<TodoState> emit) async {
    final url = '${ApiUrls.updateData}/${event.todoObj.id}';
    final uri = Uri.parse(url);
    final data = TodoModel.toJson(event.todoObj);
    final body = jsonEncode(data);
    final response = await http.put(uri, body: body, headers: header);
    if (response.statusCode == 200) {
      emit(UpdateTodoSuccessState());
    }
  }
}
