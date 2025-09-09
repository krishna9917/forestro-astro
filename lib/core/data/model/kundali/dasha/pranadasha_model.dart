class Pranadasha_Model {
  int? status;
  Response? response;

  Pranadasha_Model({this.status, this.response});

  Pranadasha_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  List<Pranadasha>? pranadasha;
  String? mahadasha;
  String? antardasha;
  String? paryantardasha;
  String? shookshamadasha;

  Response(
      {this.pranadasha,
      this.mahadasha,
      this.antardasha,
      this.paryantardasha,
      this.shookshamadasha});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['pranadasha'] != null) {
      pranadasha = <Pranadasha>[];
      json['pranadasha'].forEach((v) {
        pranadasha!.add(new Pranadasha.fromJson(v));
      });
    }
    mahadasha = json['mahadasha'];
    antardasha = json['antardasha'];
    paryantardasha = json['paryantardasha'];
    shookshamadasha = json['Shookshamadasha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pranadasha != null) {
      data['pranadasha'] = this.pranadasha!.map((v) => v.toJson()).toList();
    }
    data['mahadasha'] = this.mahadasha;
    data['antardasha'] = this.antardasha;
    data['paryantardasha'] = this.paryantardasha;
    data['Shookshamadasha'] = this.shookshamadasha;
    return data;
  }
}

class Pranadasha {
  String? name;
  String? start;
  String? end;

  Pranadasha({this.name, this.start, this.end});

  Pranadasha.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
