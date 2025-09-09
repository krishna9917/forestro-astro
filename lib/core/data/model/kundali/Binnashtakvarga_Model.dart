class Binnashtakvarga_Model {
  int? status;
  Response? response;

  Binnashtakvarga_Model({this.status, this.response});

  Binnashtakvarga_Model.fromJson(Map<String, dynamic> json) {
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
  List<int>? ascendant;
  List<int>? sun;
  List<int>? moon;
  List<int>? mars;
  List<int>? mercury;
  List<int>? jupiter;
  List<int>? saturn;
  List<int>? venus;

  Response(
      {this.ascendant,
      this.sun,
      this.moon,
      this.mars,
      this.mercury,
      this.jupiter,
      this.saturn,
      this.venus});

  Response.fromJson(Map<String, dynamic> json) {
    ascendant = json['Ascendant'].cast<int>();
    sun = json['Sun'].cast<int>();
    moon = json['Moon'].cast<int>();
    mars = json['Mars'].cast<int>();
    mercury = json['Mercury'].cast<int>();
    jupiter = json['Jupiter'].cast<int>();
    saturn = json['Saturn'].cast<int>();
    venus = json['Venus'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Ascendant'] = this.ascendant;
    data['Sun'] = this.sun;
    data['Moon'] = this.moon;
    data['Mars'] = this.mars;
    data['Mercury'] = this.mercury;
    data['Jupiter'] = this.jupiter;
    data['Saturn'] = this.saturn;
    data['Venus'] = this.venus;
    return data;
  }
}
