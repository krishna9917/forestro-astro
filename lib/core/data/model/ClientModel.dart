class ClientProfileModel {
  int? userId;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? country;
  String? state;
  String? city;
  String? profileImg;
  bool? isProfileCreated;
  String? status;
  String? dateOfBirth;
  String? birthTime;
  String? sign;
  String? wallet;
  String? createdAt;

  ClientProfileModel(
      {this.userId,
      this.name,
      this.email,
      this.phone,
      this.gender,
      this.country,
      this.state,
      this.city,
      this.profileImg,
      this.isProfileCreated,
      this.status,
      this.dateOfBirth,
      this.birthTime,
      this.sign,
      this.wallet,
      this.createdAt});

  ClientProfileModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    profileImg = json['profile_img'];
    isProfileCreated = json['is_profile_created'];
    status = json['status'];
    dateOfBirth = json['date_of_birth'];
    birthTime = json['birth_time'];
    sign = json['sign'];
    wallet = json['wallet'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['profile_img'] = this.profileImg;
    data['is_profile_created'] = this.isProfileCreated;
    data['status'] = this.status;
    data['date_of_birth'] = this.dateOfBirth;
    data['birth_time'] = this.birthTime;
    data['sign'] = this.sign;
    data['wallet'] = this.wallet;
    data['created_at'] = this.createdAt;
    return data;
  }
}
