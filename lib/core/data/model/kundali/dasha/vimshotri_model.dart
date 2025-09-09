class Vimsotridasa_Model {
  dynamic? status;
  Response? response;

  Vimsotridasa_Model({this.status, this.response});

  Vimsotridasa_Model.fromJson(Map<String, dynamic> json) {
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
  List<Mahadasha>? mahadasha;

  Response({this.mahadasha});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['mahadasha'] != null) {
      mahadasha = <Mahadasha>[];
      json['mahadasha'].forEach((v) {
        mahadasha!.add(new Mahadasha.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mahadasha != null) {
      data['mahadasha'] = this.mahadasha!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mahadasha {
  dynamic? name;
  dynamic? start;
  dynamic? end;
  dynamic? key;

  Mahadasha({this.name, this.start, this.end, this.key});

  Mahadasha.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    start = json['start'];
    end = json['end'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['start'] = this.start;
    data['end'] = this.end;
    data['key'] = this.key;
    return data;
  }
}
