class CouponModel {
  int? id;
  String? code;
  String? type;
  String? discount;
  String? discountType;
  bool? activeStatus;

  CouponModel(
      {this.id,
      this.code,
      this.type,
      this.discount,
      this.discountType,
      this.activeStatus});

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    type = json['type'];
    discount = json['discount'];
    discountType = json['discount_type'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['type'] = this.type;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['active_status'] = this.activeStatus;
    return data;
  }
}
