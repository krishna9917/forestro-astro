class Antardasha_Model {
  int? status;
  Response? response;

  Antardasha_Model({this.status, this.response});

  Antardasha_Model.fromJson(Map<String, dynamic> json) {
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
  List<Antardasha>? antardasha;
  String? mahadasha;

  Response({this.antardasha, this.mahadasha});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['antardasha'] != null) {
      antardasha = <Antardasha>[];
      json['antardasha'].forEach((v) {
        antardasha!.add(new Antardasha.fromJson(v));
      });
    }
    mahadasha = json['mahadasha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.antardasha != null) {
      data['antardasha'] = this.antardasha!.map((v) => v.toJson()).toList();
    }
    data['mahadasha'] = this.mahadasha;
    return data;
  }
}

class Antardasha {
  String? name;
  String? start;
  String? end;

  Antardasha({this.name, this.start, this.end});

  Antardasha.fromJson(Map<String, dynamic> json) {
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
