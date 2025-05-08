class AirlinesSectorList {
  String? sectorName;
  String? sectorCode;

  AirlinesSectorList({this.sectorName, this.sectorCode});

  AirlinesSectorList.fromJson(Map<String, dynamic> json) {
    sectorName = json['sectorName'];
    sectorCode = json['sectorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sectorName'] = this.sectorName;
    data['sectorCode'] = this.sectorCode;
    return data;
  }
}
