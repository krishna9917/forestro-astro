class AsedentReportModel {
  int? status;
  List<Response>? response;

  AsedentReportModel({this.status, this.response});

  AsedentReportModel.fromJson(Map<String, dynamic> json) {
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
  String? ascendant;
  String? ascendantLord;
  String? ascendantLordLocation;
  int? ascendantLordHouseLocation;
  String? generalPrediction;
  String? personalisedPrediction;
  String? verbalLocation;
  String? ascendantLordStrength;
  String? symbol;
  String? zodiacCharacteristics;
  String? luckyGem;
  String? dayForFasting;
  String? gayatriMantra;
  String? flagshipQualities;
  String? spiritualityAdvice;
  String? goodQualities;
  String? badQualities;

  Response(
      {this.ascendant,
      this.ascendantLord,
      this.ascendantLordLocation,
      this.ascendantLordHouseLocation,
      this.generalPrediction,
      this.personalisedPrediction,
      this.verbalLocation,
      this.ascendantLordStrength,
      this.symbol,
      this.zodiacCharacteristics,
      this.luckyGem,
      this.dayForFasting,
      this.gayatriMantra,
      this.flagshipQualities,
      this.spiritualityAdvice,
      this.goodQualities,
      this.badQualities});

  Response.fromJson(Map<String, dynamic> json) {
    ascendant = json['ascendant'];
    ascendantLord = json['ascendant_lord'];
    ascendantLordLocation = json['ascendant_lord_location'];
    ascendantLordHouseLocation = json['ascendant_lord_house_location'];
    generalPrediction = json['general_prediction'];
    personalisedPrediction = json['personalised_prediction'];
    verbalLocation = json['verbal_location'];
    ascendantLordStrength = json['ascendant_lord_strength'];
    symbol = json['symbol'];
    zodiacCharacteristics = json['zodiac_characteristics'];
    luckyGem = json['lucky_gem'];
    dayForFasting = json['day_for_fasting'];
    gayatriMantra = json['gayatri_mantra'];
    flagshipQualities = json['flagship_qualities'];
    spiritualityAdvice = json['spirituality_advice'];
    goodQualities = json['good_qualities'];
    badQualities = json['bad_qualities'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ascendant'] = this.ascendant;
    data['ascendant_lord'] = this.ascendantLord;
    data['ascendant_lord_location'] = this.ascendantLordLocation;
    data['ascendant_lord_house_location'] = this.ascendantLordHouseLocation;
    data['general_prediction'] = this.generalPrediction;
    data['personalised_prediction'] = this.personalisedPrediction;
    data['verbal_location'] = this.verbalLocation;
    data['ascendant_lord_strength'] = this.ascendantLordStrength;
    data['symbol'] = this.symbol;
    data['zodiac_characteristics'] = this.zodiacCharacteristics;
    data['lucky_gem'] = this.luckyGem;
    data['day_for_fasting'] = this.dayForFasting;
    data['gayatri_mantra'] = this.gayatriMantra;
    data['flagship_qualities'] = this.flagshipQualities;
    data['spirituality_advice'] = this.spiritualityAdvice;
    data['good_qualities'] = this.goodQualities;
    data['bad_qualities'] = this.badQualities;
    return data;
  }
}
