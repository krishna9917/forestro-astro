class LogModel {
  int? id;
  int? userId;
  String? name;
  String? profilePic;
  String? date;
  String? time;
  String? communicationId;
  String? status;
  String? type;
  String? communicitionTime;
  String? totalAmount;
  String? perMinCharge;

  LogModel(
      {this.id,
      this.userId,
      this.name,
      this.profilePic,
      this.date,
      this.time,
      this.communicationId,
      this.status,
      this.type,
      this.communicitionTime,
      this.totalAmount,
      this.perMinCharge});

  LogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    profilePic = json['profile_pic'];
    date = json['date'];
    time = json['time'];
    communicationId = json['communication_id'];
    status = json['status'];
    type = json['type'];
    communicitionTime = json['communicition_time'];
    totalAmount = json['total_amount'];
    perMinCharge = json['per_min_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    data['date'] = this.date;
    data['time'] = this.time;
    data['communication_id'] = this.communicationId;
    data['status'] = this.status;
    data['type'] = this.type;
    data['communicition_time'] = this.communicitionTime;
    data['total_amount'] = this.totalAmount;
    data['per_min_charge'] = this.perMinCharge;
    return data;
  }
}
