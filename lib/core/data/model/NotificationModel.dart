class NotificationModel {
  String? type;
  String? title;
  String? subtitle;
  String? userId;
  String? id;
  String? date;

  NotificationModel(
      {this.type, this.title, this.subtitle, this.userId, this.id, this.date});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    subtitle = json['subtitle'];
    userId = json['userId'];
    id = json['id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['date'] = this.date;
    return data;
  }
}
