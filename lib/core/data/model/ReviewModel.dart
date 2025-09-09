class ReviewsModel {
  String? userName;
  String? userImg;
  String? rating;
  String? comment;
  String? postDate;

  ReviewsModel(
      {this.userName, this.userImg, this.rating, this.comment, this.postDate});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    userImg = json['user_img'];
    rating = json['rating'];
    comment = json['comment'];
    postDate = json['post_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_img'] = this.userImg;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['post_date'] = this.postDate;
    return data;
  }
}
