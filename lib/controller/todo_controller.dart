import 'package:get/get.dart';
import 'package:todo/database/BDHandler.dart';
import 'package:todo/model/todo_model.dart';

class TodoController extends GetxController {
  List<TodoModel> todoList = [];

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
    update();

    // get the all todos from database
    List<Map<String, dynamic>> temp = await DBHandler.instance.todos();

    print(temp);

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
    String time = dateTime.toLocal().toString();

    DBHandler.instance.addTodo({"title": title, "create_at": "$date $time"});

    setdata();
  }

  Future<void> changeStatus(int? todoId, bool todoStatus) async {
    await DBHandler.instance.changeStatus(todoId!, todoStatus);

    setdata();
  }

  void editTodo(int id) {}

  void deleteTodo(int id) {}

  String numberFormate(int num) {
    if (num <= 9) {
      return "0$num";
    } else {
      return "$num";
    }
  }
}
