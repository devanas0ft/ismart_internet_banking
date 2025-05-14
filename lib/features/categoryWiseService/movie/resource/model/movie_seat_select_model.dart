class MovieSeatSelectModel {
  String? status;
  String? code;
  String? message;
  Details? details;
  String? detail;

  MovieSeatSelectModel(
      {this.status, this.code, this.message, this.details, this.detail});

  MovieSeatSelectModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['detail'] = detail;
    return data;
  }
}

class Details {
  String? code;
  String? message;

  Details({this.code, this.message});

  Details.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

class MovieSeatUnSelectModel {
  String? status;
  String? code;
  String? message;
  Details? details;
  String? detail;

  MovieSeatUnSelectModel(
      {this.status, this.code, this.message, this.details, this.detail});

  MovieSeatUnSelectModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['detail'] = detail;
    return data;
  }
}
