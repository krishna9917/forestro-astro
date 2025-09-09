class PlanetModel {
  dynamic status;
  Response? response;

  PlanetModel({this.status, this.response});

  PlanetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
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
  Planet? planet0;
  Planet? planet1;
  Planet? planet2_0;
  Planet? planet2_1;
  Planet? planet2_2;
  Planet? planet2_3;
  Planet? planet2_4;
  Planet? planet8_0;
  Planet? planet8_1;
  dynamic birthDasa;
  dynamic currentDasa;
  dynamic birthDasaTime;
  dynamic currentDasaTime;
  List<dynamic>? luckyGem;
  List<dynamic>? luckyNum;
  List<dynamic>? luckyColors;
  List<dynamic>? luckyLetters;
  List<dynamic>? luckyNameStart;
  dynamic rasi;
  dynamic nakshatra;
  dynamic nakshatraPada;
  Panchang? panchang;
  GhatkaChakra? ghatkaChakra;

  Response({
    this.planet0,
    this.planet1,
    this.planet2_0,
    this.planet2_1,
    this.planet2_2,
    this.planet2_3,
    this.planet2_4,
    this.planet8_0,
    this.planet8_1,
    this.birthDasa,
    this.currentDasa,
    this.birthDasaTime,
    this.currentDasaTime,
    this.luckyGem,
    this.luckyNum,
    this.luckyColors,
    this.luckyLetters,
    this.luckyNameStart,
    this.rasi,
    this.nakshatra,
    this.nakshatraPada,
    this.panchang,
    this.ghatkaChakra,
  });

  Response.fromJson(Map<String, dynamic> json) {
    planet0 = json['0'] != null ? Planet.fromJson(json['0']) : null;
    planet1 = json['1'] != null ? Planet.fromJson(json['1']) : null;
    planet2_0 = json['2_0'] != null ? Planet.fromJson(json['2_0']) : null;
    planet2_1 = json['2_1'] != null ? Planet.fromJson(json['2_1']) : null;
    planet2_2 = json['2_2'] != null ? Planet.fromJson(json['2_2']) : null;
    planet2_3 = json['2_3'] != null ? Planet.fromJson(json['2_3']) : null;
    planet2_4 = json['2_4'] != null ? Planet.fromJson(json['2_4']) : null;
    planet8_0 = json['8_0'] != null ? Planet.fromJson(json['8_0']) : null;
    planet8_1 = json['8_1'] != null ? Planet.fromJson(json['8_1']) : null;
    birthDasa = json['birth_dasa'];
    currentDasa = json['current_dasa'];
    birthDasaTime = json['birth_dasa_time'];
    currentDasaTime = json['current_dasa_time'];
    luckyGem =
        json['lucky_gem'] != null ? List<String>.from(json['lucky_gem']) : null;
    luckyNum =
        json['lucky_num'] != null ? List<int>.from(json['lucky_num']) : null;
    luckyColors = json['lucky_colors'] != null
        ? List<String>.from(json['lucky_colors'])
        : null;
    luckyLetters = json['lucky_letters'] != null
        ? List<String>.from(json['lucky_letters'])
        : null;
    luckyNameStart = json['lucky_name_start'] != null
        ? List<String>.from(json['lucky_name_start'])
        : null;
    rasi = json['rasi'];
    nakshatra = json['nakshatra'];
    nakshatraPada = json['nakshatra_pada'];
    panchang =
        json['panchang'] != null ? Panchang.fromJson(json['panchang']) : null;
    ghatkaChakra = json['ghatka_chakra'] != null
        ? GhatkaChakra.fromJson(json['ghatka_chakra'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (planet0 != null) data['0'] = planet0!.toJson();
    if (planet1 != null) data['1'] = planet1!.toJson();
    if (planet2_0 != null) data['2_0'] = planet2_0!.toJson();
    if (planet2_1 != null) data['2_1'] = planet2_1!.toJson();
    if (planet2_2 != null) data['2_2'] = planet2_2!.toJson();
    if (planet2_3 != null) data['2_3'] = planet2_3!.toJson();
    if (planet2_4 != null) data['2_4'] = planet2_4!.toJson();
    if (planet8_0 != null) data['8_0'] = planet8_0!.toJson();
    if (planet8_1 != null) data['8_1'] = planet8_1!.toJson();
    data['birth_dasa'] = birthDasa;
    data['current_dasa'] = currentDasa;
    data['birth_dasa_time'] = birthDasaTime;
    data['current_dasa_time'] = currentDasaTime;
    data['lucky_gem'] = luckyGem;
    data['lucky_num'] = luckyNum;
    data['lucky_colors'] = luckyColors;
    data['lucky_letters'] = luckyLetters;
    data['lucky_name_start'] = luckyNameStart;
    data['rasi'] = rasi;
    data['nakshatra'] = nakshatra;
    data['nakshatra_pada'] = nakshatraPada;
    if (panchang != null) data['panchang'] = panchang!.toJson();
    if (ghatkaChakra != null) data['ghatka_chakra'] = ghatkaChakra!.toJson();
    return data;
  }
}

class Planet {
  dynamic name;
  dynamic fullName;
  dynamic localDegree;
  dynamic globalDegree;
  dynamic progressInPercentage;
  dynamic rasiNo;
  dynamic zodiac;
  dynamic house;
  dynamic speedRadiansPerDay;
  dynamic retro;
  dynamic nakshatra;
  dynamic nakshatraLord;
  dynamic nakshatraPada;
  dynamic nakshatraNo;
  dynamic zodiacLord;
  dynamic isPlanetSet;
  dynamic basicAvastha;
  dynamic lordStatus;
  dynamic isCombust;

  Planet({
    this.name,
    this.fullName,
    this.localDegree,
    this.globalDegree,
    this.progressInPercentage,
    this.rasiNo,
    this.zodiac,
    this.house,
    this.speedRadiansPerDay,
    this.retro,
    this.nakshatra,
    this.nakshatraLord,
    this.nakshatraPada,
    this.nakshatraNo,
    this.zodiacLord,
    this.isPlanetSet,
    this.basicAvastha,
    this.lordStatus,
    this.isCombust,
  });

  Planet.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fullName = json['full_name'];
    localDegree = json['local_degree'];
    globalDegree = json['global_degree'];
    progressInPercentage = json['progress_in_percentage'];
    rasiNo = json['rasi_no'];
    zodiac = json['zodiac'];
    house = json['house'];
    speedRadiansPerDay = json['speed_radians_per_day'];
    retro = json['retro'];
    nakshatra = json['nakshatra'];
    nakshatraLord = json['nakshatra_lord'];
    nakshatraPada = json['nakshatra_pada'];
    nakshatraNo = json['nakshatra_no'];
    zodiacLord = json['zodiac_lord'];
    isPlanetSet = json['is_planet_set'];
    basicAvastha = json['basic_avastha'];
    lordStatus = json['lord_status'];
    isCombust = json['is_combust'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['full_name'] = this.fullName;
    data['local_degree'] = this.localDegree;
    data['global_degree'] = this.globalDegree;
    data['progress_in_percentage'] = this.progressInPercentage;
    data['rasi_no'] = this.rasiNo;
    data['zodiac'] = this.zodiac;
    data['house'] = this.house;
    data['speed_radians_per_day'] = this.speedRadiansPerDay;
    data['retro'] = this.retro;
    data['nakshatra'] = this.nakshatra;
    data['nakshatra_lord'] = this.nakshatraLord;
    data['nakshatra_pada'] = this.nakshatraPada;
    data['nakshatra_no'] = this.nakshatraNo;
    data['zodiac_lord'] = this.zodiacLord;
    data['is_planet_set'] = this.isPlanetSet;
    data['basic_avastha'] = this.basicAvastha;
    data['lord_status'] = this.lordStatus;
    data['is_combust'] = this.isCombust;
    return data;
  }
}

class Panchang {
  // Define the attributes and methods for Panchang class
  Panchang.fromJson(Map<String, dynamic> json) {
    // Parse the JSON data
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // Serialize the data to JSON
    return data;
  }
}

class GhatkaChakra {
  // Define the attributes and methods for GhatkaChakra class
  GhatkaChakra.fromJson(Map<String, dynamic> json) {
    // Parse the JSON data
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // Serialize the data to JSON
    return data;
  }
}
