class TotalReportModel {
  bool? status;
  int? numberOfAudioCall;
  int? numberOfVideoCalls;
  int? numberOfChats;
  String? totalEarning;

  TotalReportModel(
      {this.status,
      this.numberOfAudioCall,
      this.numberOfVideoCalls,
      this.numberOfChats,
      this.totalEarning});

  TotalReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    numberOfAudioCall = json['number_of_audio_call'];
    numberOfVideoCalls = json['number_of_video_calls'];
    numberOfChats = json['number_of_chats'];
    totalEarning = json['total_earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['number_of_audio_call'] = numberOfAudioCall;
    data['number_of_video_calls'] = numberOfVideoCalls;
    data['number_of_chats'] = numberOfChats;
    data['total_earning'] = totalEarning;
    return data;
  }
}
