class KpHouseModel {
  int? status;
  List<Response>? response;

  KpHouseModel({this.status, this.response});

  KpHouseModel.fromJson(Map<String, dynamic> json) {
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
  String? startRasi;
  String? endRasi;
  double? localStartDegree;
  double? localEndDegree;
  double? length;
  int? house;
  double? bhavmadhya;
  double? globalStartDegree;
  double? globalEndDegree;
  String? startNakshatraLord;
  String? endNakshatraLord;
  List<Planets>? planets;
  String? cuspSubLord;
  String? cuspSubSubLord;

  Response(
      {this.startRasi,
      this.endRasi,
      this.localStartDegree,
      this.localEndDegree,
      this.length,
      this.house,
      this.bhavmadhya,
      this.globalStartDegree,
      this.globalEndDegree,
      this.startNakshatraLord,
      this.endNakshatraLord,
      this.planets,
      this.cuspSubLord,
      this.cuspSubSubLord});

  Response.fromJson(Map<String, dynamic> json) {
    startRasi = json['start_rasi'];
    endRasi = json['end_rasi'];
    localStartDegree = json['local_start_degree'];
    localEndDegree = json['local_end_degree'];
    length = json['length'];
    house = json['house'];
    bhavmadhya = json['bhavmadhya'];
    globalStartDegree = json['global_start_degree'];
    globalEndDegree = json['global_end_degree'];
    startNakshatraLord = json['start_nakshatra_lord'];
    endNakshatraLord = json['end_nakshatra_lord'];
    if (json['planets'] != null) {
      planets = <Planets>[];
      json['planets'].forEach((v) {
        planets!.add(new Planets.fromJson(v));
      });
    }
    cuspSubLord = json['cusp_sub_lord'];
    cuspSubSubLord = json['cusp_sub_sub_lord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_rasi'] = this.startRasi;
    data['end_rasi'] = this.endRasi;
    data['local_start_degree'] = this.localStartDegree;
    data['local_end_degree'] = this.localEndDegree;
    data['length'] = this.length;
    data['house'] = this.house;
    data['bhavmadhya'] = this.bhavmadhya;
    data['global_start_degree'] = this.globalStartDegree;
    data['global_end_degree'] = this.globalEndDegree;
    data['start_nakshatra_lord'] = this.startNakshatraLord;
    data['end_nakshatra_lord'] = this.endNakshatraLord;
    if (this.planets != null) {
      data['planets'] = this.planets!.map((v) => v.toJson()).toList();
    }
    data['cusp_sub_lord'] = this.cuspSubLord;
    data['cusp_sub_sub_lord'] = this.cuspSubSubLord;
    return data;
  }
}

class Planets {
  String? planetId;
  String? fullName;
  String? name;
  String? nakshatra;
  int? nakshatraNo;
  int? nakshatraPada;
  bool? retro;

  Planets(
      {this.planetId,
      this.fullName,
      this.name,
      this.nakshatra,
      this.nakshatraNo,
      this.nakshatraPada,
      this.retro});

  Planets.fromJson(Map<String, dynamic> json) {
    planetId = json['planetId'];
    fullName = json['full_name'];
    name = json['name'];
    nakshatra = json['nakshatra'];
    nakshatraNo = json['nakshatra_no'];
    nakshatraPada = json['nakshatra_pada'];
    retro = json['retro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planetId'] = this.planetId;
    data['full_name'] = this.fullName;
    data['name'] = this.name;
    data['nakshatra'] = this.nakshatra;
    data['nakshatra_no'] = this.nakshatraNo;
    data['nakshatra_pada'] = this.nakshatraPada;
    data['retro'] = this.retro;
    return data;
  }
}
