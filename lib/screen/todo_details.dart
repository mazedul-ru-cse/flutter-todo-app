import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:todo/model/todo_model.dart';

class TodoDetails extends StatefulWidget {
  const TodoDetails({super.key, required this.todoModel, required this.index});

  final TodoModel todoModel;
  final int index;

  @override
  State<TodoDetails> createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  TodoController todoController = Get.put(TodoController());

  final todoEditController = TextEditingController();

  @override
  void initState() {
    todoEditController.text = widget.todoModel.title.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDos Details"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: getTodoDetailsbody(),
    );
  }

  Widget getTodoDetailsbody() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: mBlue),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [statusButton(), editButton()],
        ),
        todoValue()
      ]),
    );
  }

  Widget statusButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 5, top: 15),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.green.shade800,
            foregroundColor: Colors.white),
        child: Text("Change Status"),
        onPressed: () => todoController.todoList[widget.index].status == 1
            ? todoController.changeStatus(widget.todoModel.id, false)
            : todoController.changeStatus(widget.todoModel.id, true),
      ),
    );
  }

  Widget editButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 15, bottom: 5, top: 15),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade600,
            foregroundColor: Colors.white),
        child: Text("Edit"),
        onPressed: () => todoEditDialog(),
      ),
    );
  }

  Widget todoValue() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                todoController.todoList[widget.index].title.toString(),
                style: GoogleFonts.alike(
                    textStyle: Theme.of(context).textTheme.titleMedium),
              ),
              subtitle: Text(
                  todoController.todoList[widget.index].createAt.toString(),
                  style: GoogleFonts.alike()),
            ),

            // Status
            todoController.todoList[widget.index].status == 1
                ? Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Completed",
                      style:
                          GoogleFonts.acme(fontSize: 18, color: Colors.green),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Incompled",
                      style: GoogleFonts.acme(fontSize: 18, color: mGrey),
                    ),
                  )
          ],
        ));
  }

  Future todoEditDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Edit"),
            content: TextField(
              controller: todoEditController,
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
                        todoController.editTodo(
                            widget.todoModel.id!, todoEditController.text);
                      }),
                ],
              )
            ],
          ));
}
