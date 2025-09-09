class MyFollowerModel {
  int? id;
  int? astrologierId;
  int? userId;
  String? userName;
  String? profileImg;
  String? notificationToken;

  MyFollowerModel(
      {this.id,
      this.astrologierId,
      this.userId,
      this.userName,
      this.profileImg,
      this.notificationToken});

  MyFollowerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    astrologierId = json['astrologier_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    profileImg = json['profile_img'];
    notificationToken = json['notification_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['astrologier_id'] = this.astrologierId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['profile_img'] = this.profileImg;
    data['notification_token'] = this.notificationToken;
    return data;
  }
}
