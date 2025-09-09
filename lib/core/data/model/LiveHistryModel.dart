class AstroLiveHistoryModel {
  final time;
  final totalAmount;
  final astrologerLiveChargesPerMin;
  final DateTime dateTime;

  AstroLiveHistoryModel({
    required this.time,
    required this.totalAmount,
    required this.astrologerLiveChargesPerMin,
    required this.dateTime,
  });

  factory AstroLiveHistoryModel.fromJson(Map<String, dynamic> json) {
    return AstroLiveHistoryModel(
      time: json['time'],
      totalAmount: json['total_amount'],
      astrologerLiveChargesPerMin: json['astrologer_live_charges_per_min'],
      dateTime: DateTime.parse(json['date_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'total_amount': totalAmount,
      'astrologer_live_charges_per_min': astrologerLiveChargesPerMin,
      'date_time': dateTime.toIso8601String(),
    };
  }
}
