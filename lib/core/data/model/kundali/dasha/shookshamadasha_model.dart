class Shookshamadasha_Model {
  int? status;
  Response? response;

  Shookshamadasha_Model({this.status, this.response});

  Shookshamadasha_Model.fromJson(Map<String, dynamic> json) {
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
  List<Shookshamadasha>? shookshamadasha;
  String? mahadasha;
  String? antardasha;
  String? paryantardasha;

  Response(
      {this.shookshamadasha,
      this.mahadasha,
      this.antardasha,
      this.paryantardasha});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['shookshamadasha'] != null) {
      shookshamadasha = <Shookshamadasha>[];
      json['shookshamadasha'].forEach((v) {
        shookshamadasha!.add(new Shookshamadasha.fromJson(v));
      });
    }
    mahadasha = json['mahadasha'];
    antardasha = json['antardasha'];
    paryantardasha = json['paryantardasha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shookshamadasha != null) {
      data['shookshamadasha'] =
          this.shookshamadasha!.map((v) => v.toJson()).toList();
    }
    data['mahadasha'] = this.mahadasha;
    data['antardasha'] = this.antardasha;
    data['paryantardasha'] = this.paryantardasha;
    return data;
  }
}

class Shookshamadasha {
  String? name;
  String? start;
  String? end;

  Shookshamadasha({this.name, this.start, this.end});

  Shookshamadasha.fromJson(Map<String, dynamic> json) {
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
