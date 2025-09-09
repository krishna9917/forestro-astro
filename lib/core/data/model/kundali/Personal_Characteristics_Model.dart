class Personal_Characteristics_Model {
  int? status;
  List<Response>? response;

  Personal_Characteristics_Model({this.status, this.response});

  Personal_Characteristics_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  int? currentHouse;
  String? verbalLocation;
  String? currentZodiac;
  String? lordOfZodiac;
  String? lordZodiacLocation;
  int? lordHouseLocation;
  String? personalisedPrediction;
  String? lordStrength;

  Response(
      {this.currentHouse,
      this.verbalLocation,
      this.currentZodiac,
      this.lordOfZodiac,
      this.lordZodiacLocation,
      this.lordHouseLocation,
      this.personalisedPrediction,
      this.lordStrength});

  Response.fromJson(Map<String, dynamic> json) {
    currentHouse = json['current_house'];
    verbalLocation = json['verbal_location'];
    currentZodiac = json['current_zodiac'];
    lordOfZodiac = json['lord_of_zodiac'];
    lordZodiacLocation = json['lord_zodiac_location'];
    lordHouseLocation = json['lord_house_location'];
    personalisedPrediction = json['personalised_prediction'];
    lordStrength = json['lord_strength'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_house'] = this.currentHouse;
    data['verbal_location'] = this.verbalLocation;
    data['current_zodiac'] = this.currentZodiac;
    data['lord_of_zodiac'] = this.lordOfZodiac;
    data['lord_zodiac_location'] = this.lordZodiacLocation;
    data['lord_house_location'] = this.lordHouseLocation;
    data['personalised_prediction'] = this.personalisedPrediction;
    data['lord_strength'] = this.lordStrength;
    return data;
  }
}
