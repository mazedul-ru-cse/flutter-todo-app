class TodoModel {
  int? id;
  String? title;
  int? status;
  String? createAt;

  TodoModel(this.id, this.title, this.status, this.createAt);

  TodoModel.formMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    status = map["status"];
    createAt = map["create_at"];
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "status": status, "create_at": createAt};
  }
}
