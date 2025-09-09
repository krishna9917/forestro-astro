class PayoutsModel {
  int? id;
  String? amount;
  String? startWeekDay;
  String? endWeekDay;
  String? paymentStatus;

  PayoutsModel(
      {this.id,
      this.amount,
      this.startWeekDay,
      this.endWeekDay,
      this.paymentStatus});

  PayoutsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    startWeekDay = json['start_week_day'];
    endWeekDay = json['end_week_day'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['start_week_day'] = this.startWeekDay;
    data['end_week_day'] = this.endWeekDay;
    data['payment_status'] = this.paymentStatus;
    return data;
  }
}
