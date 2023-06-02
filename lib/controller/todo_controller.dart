import 'package:get/get.dart';
import 'package:todo/database/BDHandler.dart';
import 'package:todo/model/todo_model.dart';

class TodoController extends GetxController {
  RxList<TodoModel> todoList = <TodoModel>[].obs;

  bool isLoading = true;

  @override
  void onInit() {
    setdata();

    super.onInit();
  }

  // Initialize
  void setdata() async {
    todoList.clear();

    isLoading = true;
    //update();

    // get the all todos from database
    List<Map<String, dynamic>> temp = await DBHandler.instance.todos();

    //print(temp);

    // added the all todos in todosList
    for (var value in temp) {
      todoList.add(TodoModel.formMap(value));
    }

    isLoading = false;
    update();
  }

  void addTodo(String title) async {
    DateTime dateTime = DateTime.now();

    //Current date and time
    String date =
        "${numberFormate(dateTime.day)}-${numberFormate(dateTime.month)}-${numberFormate(dateTime.year)}";
    String time =
        "${numberFormate(dateTime.hour)}:${numberFormate(dateTime.minute)}";

    DBHandler.instance.addTodo({"title": title, "create_at": "$date $time"});

    setdata();
  }

  void changeStatus(int? todoId, bool todoStatus) async {
    await DBHandler.instance.changeStatus(todoId!, todoStatus);

    setdata();
  }

  void editTodo(int todoId, String title) async {
    await DBHandler.instance.editTodo(todoId, title);

    setdata();
  }

  void searchTodos(String keyword) async {
    todoList.clear();

    List<Map<String, dynamic>> temp =
        await DBHandler.instance.searchTodos(keyword);

    // added the all todos in todosList
    for (var value in temp) {
      todoList.add(TodoModel.formMap(value));
    }

    update();
  }

  void deleteTodo(int? todoId) {
    DBHandler.instance.deleteTodo(todoId!);
    setdata();
  }

  String numberFormate(int num) {
    if (num <= 9) {
      return "0$num";
    } else {
      return "$num";
    }
  }
}
