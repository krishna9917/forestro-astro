import 'dart:async';

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

  // New fields
  int elapsedSeconds = 0; // कितने seconds हो गए
  Timer? timer;           // हर object का अपना timer

  CommunicationModel({
    this.id,
    this.userId,
    this.userWallet,
    this.slot,
    this.name,
    this.profilePic,
    this.date,
    this.time,
    this.communicationId,
    this.status,
    this.type,
  });

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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['slot'] = slot;
    data['user_id'] = userId;
    data['name'] = name;
    data['profile_pic'] = profilePic;
    data['date'] = date;
    data['time'] = time;
    data['communication_id'] = communicationId;
    data['status'] = status;
    data['type'] = type;
    return data;
  }
}