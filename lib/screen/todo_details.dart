import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/screen/home_screen.dart';

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 15),
            statusButton(),
            SizedBox(width: 10),
            editButton(),
            SizedBox(width: 10),
            deleteButton()
          ],
        ),
        todoValue()
      ]),
    );
  }

  Widget statusButton() {
    return Container(
        padding: EdgeInsets.all(0),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          color: Colors.white,
          icon: Icon(Icons.published_with_changes_outlined),
          iconSize: 18,
          onPressed: () => todoController.todoList[widget.index].status == 1
              ? todoController.changeStatus(widget.todoModel.id, false)
              : todoController.changeStatus(widget.todoModel.id, true),
        ));
  }

  Widget editButton() {
    return Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.symmetric(vertical: 12),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          color: Colors.white,
          icon: Icon(Icons.edit),
          iconSize: 18,
          onPressed: () => todoEditDialog(),
        ));
  }

  Widget deleteButton() {
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
          icon: Icon(
            Icons.delete,
          ),
          iconSize: 18,
          onPressed: () {
            todoController.deleteTodo(widget.todoModel.id);
            Get.back();
          },
        ));
  }

  Widget todoValue() {
    return Obx(() => todoController.todoList.isNotEmpty
        ? Column(
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
                        "Incompleted",
                        style: GoogleFonts.acme(fontSize: 18, color: mGrey),
                      ),
                    )
            ],
          )
        : Text("Loading..."));
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
