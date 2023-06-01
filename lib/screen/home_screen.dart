import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/controller/todo_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final todoTitleController = TextEditingController();

  //Todo controller for state management
  TodoController todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      floatingActionButton: addTodoButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Widget body
  Widget getBody() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "All tasks",
              style: GoogleFonts.acme(fontSize: 18),
            ),
            Expanded(child: displayTodos()),
          ],
        ),
      ),
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
            return Card(
              child: ListTile(
                leading: Text("${index + 1}"),
                title: Text(todos.todoList[index].title.toString()),
              ),
            );
          },
        );
      },
    );
  }
}
