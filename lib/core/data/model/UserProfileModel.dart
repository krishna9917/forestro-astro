class UserProfileModel {
  int? astroId;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? adharId;
  String? panNumber;
  String? specialization;
  List<String>? languaage;
  List<Certifications>? certifications;
  String? address;
  String? state;
  String? city;
  String? pinCode;
  String? profileImg;
  bool? isProfileCreated;
  String? status;
  String? trusted;
  String? dateOfBirth;
  String? birthPlace;
  String? experience;
  String? callChargesPerMin;
  String? chatChargesPerMin;
  String? videoChargesPerMin;
  String? wallet;
  String? astrologerLiveChargesPerMin;
  String? boostCharges;
  String? profileStatus;
  String? education;
  String? description;
  String? startTimeSlot;
  String? endTimeSlot;
  String? isOnline;
  String? boostedAt;
  String? createdAt;
  bool? isOnboardingCompleted;
  String? score;

  UserProfileModel(
      {this.astroId,
      this.name,
      this.email,
      this.phone,
      this.gender,
      this.adharId,
      this.panNumber,
      this.specialization,
      this.languaage,
      this.certifications,
      this.address,
      this.state,
      this.city,
      this.pinCode,
      this.profileImg,
      this.isProfileCreated,
      this.status,
      this.trusted,
      this.dateOfBirth,
      this.birthPlace,
      this.experience,
      this.callChargesPerMin,
      this.chatChargesPerMin,
      this.videoChargesPerMin,
      this.wallet,
      this.astrologerLiveChargesPerMin,
      this.boostCharges,
      this.profileStatus,
      this.education,
      this.description,
      this.startTimeSlot,
      this.endTimeSlot,
      this.isOnline,
      this.boostedAt,
      this.createdAt,
      this.isOnboardingCompleted,
      this.score = "0"});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    astroId = json['astro_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    adharId = json['adhar_id'];
    panNumber = json['pan_number'];
    specialization = json['specialization'];
    languaage = json['languaage'].cast<String>();
    if (json['certifications'] != null) {
      certifications = <Certifications>[];
      json['certifications'].forEach((v) {
        certifications!.add(new Certifications.fromJson(v));
      });
    }
    address = json['address'];
    state = json['state'];
    city = json['city'];
    pinCode = json['pin_code'];
    profileImg = json['profile_img'];
    isProfileCreated = json['is_profile_created'];
    status = json['status'];
    trusted = json['trusted'];
    dateOfBirth = json['date_of_birth'];
    birthPlace = json['birth_place'];
    experience = json['experience'];
    callChargesPerMin = json['call_charges_per_min'];
    chatChargesPerMin = json['chat_charges_per_min'];
    videoChargesPerMin = json['video_charges_per_min'];
    wallet = json['wallet'];
    astrologerLiveChargesPerMin = json['astrologer_live_charges_per_min'];
    boostCharges = json['boost_charges'];
    profileStatus = json['profile_status'];
    education = json['education'];
    description = json['description'];
    startTimeSlot = json['start_time_slot'];
    endTimeSlot = json['end_time_slot'];
    isOnline = json['is_online'];
    boostedAt = json['boosted_at'];
    createdAt = json['created_at'];
    isOnboardingCompleted = json['is_onboarding_completed'];
    score = json['score'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['astro_id'] = this.astroId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['adhar_id'] = this.adharId;
    data['pan_number'] = this.panNumber;
    data['specialization'] = this.specialization;
    data['languaage'] = this.languaage;
    if (this.certifications != null) {
      data['certifications'] =
          this.certifications!.map((v) => v.toJson()).toList();
    }
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['pin_code'] = this.pinCode;
    data['profile_img'] = this.profileImg;
    data['is_profile_created'] = this.isProfileCreated;
    data['status'] = this.status;
    data['trusted'] = this.trusted;
    data['date_of_birth'] = this.dateOfBirth;
    data['birth_place'] = this.birthPlace;
    data['experience'] = this.experience;
    data['call_charges_per_min'] = this.callChargesPerMin;
    data['chat_charges_per_min'] = this.chatChargesPerMin;
    data['video_charges_per_min'] = this.videoChargesPerMin;
    data['wallet'] = this.wallet;
    data['astrologer_live_charges_per_min'] = this.astrologerLiveChargesPerMin;
    data['boost_charges'] = this.boostCharges;
    data['profile_status'] = this.profileStatus;
    data['education'] = this.education;
    data['description'] = this.description;
    data['start_time_slot'] = this.startTimeSlot;
    data['end_time_slot'] = this.endTimeSlot;
    data['is_online'] = this.isOnline;
    data['boosted_at'] = this.boostedAt;
    data['created_at'] = this.createdAt;
    data['is_onboarding_completed'] = this.isOnboardingCompleted;
    data['score'] = score;
    return data;
  }
}

class Certifications {
  int? certificateId;
  String? certificate;
  String? fileSize;

  Certifications({this.certificateId, this.certificate, this.fileSize});

  Certifications.fromJson(Map<String, dynamic> json) {
    certificateId = json['certificate_id'];
    certificate = json['certificate'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['certificate_id'] = this.certificateId;
    data['certificate'] = this.certificate;
    data['file_size'] = this.fileSize;
    return data;
  }
}
