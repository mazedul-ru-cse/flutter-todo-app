import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/screen/todo_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Todo controller for state management
  TodoController todoController = Get.put(TodoController());

  //Text Field controller
  final searchController = TextEditingController();
  final todoTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mBGColor,
      body: getBody(),
      floatingActionButton: addTodoButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Widget body
  Widget getBody() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchBox(),
          getTitle(),
          SizedBox(
            height: 10,
          ),
          Expanded(child: displayTodos()),
        ],
      ),
    );
  }

  //Search box

  Widget searchBox() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(
              Icons.search,
              color: mBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 25),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(color: mGrey)),
        onChanged: (keyword) => todoController.searchTodos(keyword),
      ),
    );
  }

  //Title

  Widget getTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 10, 20),
      child: Text("All ToDos",
          textAlign: TextAlign.left, style: GoogleFonts.acme(fontSize: 23)),
    );
  }

  // Add a new todo
  Widget addTodoButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => todoAddDialog(),
    );
  }

  // Todo add dialog
  Future todoAddDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Create a task"),
            content: TextField(
              controller: todoTitleController,
              decoration: InputDecoration(hintText: "Enter your todo name"),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Close dialog button
                  TextButton(
                      child: Text("Close"),
                      onPressed: () => Navigator.of(context).pop()),

                  // Submit dialog button
                  TextButton(
                      child: Text("Submit"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        todoController.addTodo(todoTitleController.text);
                        todoTitleController.clear();
                      }),
                ],
              )
            ],
          ));

  //Showing all todos
  Widget displayTodos() {
    return GetBuilder<TodoController>(
      init: TodoController(),
      builder: (todos) {
        if (todos.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: todos.todoList.length,
          itemBuilder: (context, index) {
            TodoModel todoModel = todos.todoList[index];

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                //Todo details page
                onTap: () {
                  Get.to(TodoDetails(
                    todoModel: todoModel,
                    index: index,
                  ));
                },

                //todo status
                leading: changeStatus(todoModel, index),

                //todo title
                title: todoModel.status == 1
                    ? Text(
                        todoModel.title.toString(),
                        style:
                            TextStyle(decoration: TextDecoration.lineThrough),
                      )
                    : Text(
                        todoModel.title.toString(),
                        style: GoogleFonts.alike(
                            textStyle: Theme.of(context).textTheme.titleMedium),
                      ),

                trailing: deleteButton(todoModel.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget changeStatus(TodoModel todoModel, int index) {
    return todoModel.status == 1
        ? IconButton(
            icon: Icon(
              Icons.check_circle,
              color: Colors.lightBlue,
              size: 25,
            ),
            onPressed: () => todoController.changeStatus(todoModel.id, false),
          )
        : IconButton(
            icon: Icon(Icons.radio_button_unchecked_rounded),
            onPressed: () => todoController.changeStatus(todoModel.id, true),
          );
  }

  Widget deleteButton(int? todoId) {
    return Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.symmetric(vertical: 12),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: mRed,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          color: Colors.white,
          icon: Icon(Icons.delete),
          iconSize: 17,
          onPressed: () => todoController.deleteTodo(todoId),
        ));
  }
}
