class MovieSeatModel {
  String? status;
  String? code;
  String? message;
  MovieDetails? details;
  String? detail;

  MovieSeatModel(
      {this.status, this.code, this.message, this.details, this.detail});

  MovieSeatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    details =
        json['details'] != null ? MovieDetails.fromJson(json['details']) : null;
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

class MovieDetails {
  String? code;
  String? message;
  String? processId;
  String? theaterName;
  String? theaterAddress;
  String? theaterLogo;
  String? movieId;
  String? showId;
  String? screenName;
  String? showDate;
  String? showTime;
  String? movieName;
  String? genre;
  String? duration;
  String? maxSeatSelection;
  String? holdTime;
  List<SeatRows>? seatRows;

  MovieDetails(
      {this.code,
      this.message,
      this.processId,
      this.theaterName,
      this.theaterAddress,
      this.theaterLogo,
      this.movieId,
      this.showId,
      this.screenName,
      this.showDate,
      this.showTime,
      this.movieName,
      this.genre,
      this.duration,
      this.maxSeatSelection,
      this.holdTime,
      this.seatRows});

  MovieDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    processId = json['processId'];
    theaterName = json['theaterName'];
    theaterAddress = json['theaterAddress'];
    theaterLogo = json['theaterLogo'];
    movieId = json['movieId'];
    showId = json['showId'];
    screenName = json['screenName'];
    showDate = json['showDate'];
    showTime = json['showTime'];
    movieName = json['movieName'];
    genre = json['genre'];
    duration = json['duration'];
    maxSeatSelection = json['maxSeatSelection'];
    holdTime = json['holdTime'];
    if (json['seatRows'] != null) {
      seatRows = <SeatRows>[];
      json['seatRows'].forEach((v) {
        seatRows!.add(SeatRows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['processId'] = processId;
    data['theaterName'] = theaterName;
    data['theaterAddress'] = theaterAddress;
    data['theaterLogo'] = theaterLogo;
    data['movieId'] = movieId;
    data['showId'] = showId;
    data['screenName'] = screenName;
    data['showDate'] = showDate;
    data['showTime'] = showTime;
    data['movieName'] = movieName;
    data['genre'] = genre;
    data['duration'] = duration;
    data['maxSeatSelection'] = maxSeatSelection;
    data['holdTime'] = holdTime;
    if (seatRows != null) {
      data['seatRows'] = seatRows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeatRows {
  String? category;
  String? rowName;
  List<Seats>? seats;

  SeatRows({this.category, this.rowName, this.seats});

  SeatRows.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    rowName = json['rowName'];
    if (json['seats'] != null) {
      seats = <Seats>[];
      json['seats'].forEach((v) {
        seats!.add(Seats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['rowName'] = rowName;
    if (seats != null) {
      data['seats'] = seats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Seats {
  String? price;
  String? seatId;
  String? seatName;
  String? status;

  Seats({this.price, this.seatId, this.seatName, this.status});

  Seats.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    seatId = json['seatId'];
    seatName = json['seatName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['seatId'] = seatId;
    data['seatName'] = seatName;
    data['status'] = status;
    return data;
  }
}
