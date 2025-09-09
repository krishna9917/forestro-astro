class BankModel {
  int? id;
  int? astroId;
  String? name;
  String? accountNumber;
  String? ifsc;
  String? status;

  BankModel(
      {this.id,
      this.astroId,
      this.name,
      this.accountNumber,
      this.ifsc,
      this.status});

  BankModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    astroId = json['astro_id'];
    name = json['name'];
    accountNumber = json['account_number'];
    ifsc = json['ifsc'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['astro_id'] = this.astroId;
    data['name'] = this.name;
    data['account_number'] = this.accountNumber;
    data['ifsc'] = this.ifsc;
    data['status'] = this.status;
    return data;
  }
}
