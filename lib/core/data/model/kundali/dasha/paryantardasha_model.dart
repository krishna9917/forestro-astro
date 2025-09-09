class Paryantardasha_Model {
  int? status;
  Response? response;

  Paryantardasha_Model({this.status, this.response});

  Paryantardasha_Model.fromJson(Map<String, dynamic> json) {
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
  List<Paryantardasha>? paryantardasha;
  String? mahadasha;
  String? antardasha;

  Response({this.paryantardasha, this.mahadasha, this.antardasha});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['paryantardasha'] != null) {
      paryantardasha = <Paryantardasha>[];
      json['paryantardasha'].forEach((v) {
        paryantardasha!.add(new Paryantardasha.fromJson(v));
      });
    }
    mahadasha = json['mahadasha'];
    antardasha = json['antardasha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paryantardasha != null) {
      data['paryantardasha'] =
          this.paryantardasha!.map((v) => v.toJson()).toList();
    }
    data['mahadasha'] = this.mahadasha;
    data['antardasha'] = this.antardasha;
    return data;
  }
}

class Paryantardasha {
  String? name;
  String? start;
  String? end;

  Paryantardasha({this.name, this.start, this.end});

  Paryantardasha.fromJson(Map<String, dynamic> json) {
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
