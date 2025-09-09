class CommunicationModel {
  int? slot;
  int? id;
  int? userId;
  int? userWallet;
  String? name;
  String? profilePic;
  String? date;
  String? time;
  String? communicationId;
  String? status;
  String? type;

  CommunicationModel(
      {this.id,
      this.userId,
      this.userWallet,
      this.slot,
      this.name,
      this.profilePic,
      this.date,
      this.time,
      this.communicationId,
      this.status,
      this.type});

  CommunicationModel.fromJson(Map<String, dynamic> json) {
    slot = json['slot'];
    id = json['id'];
    userId = json['user_id'];
    userWallet = json['user_wallet'];
    name = json['name'];
    profilePic = json['profile_pic'];
    date = json['date'];
    time = json['time'];
    communicationId = json['communication_id'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slot'] = this.slot;
    data['user_id'] = this.userId;
    data['user_id'] = userId;
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    data['date'] = this.date;
    data['time'] = this.time;
    data['communication_id'] = this.communicationId;
    data['status'] = this.status;
    data['type'] = this.type;
    return data;
  }
}
