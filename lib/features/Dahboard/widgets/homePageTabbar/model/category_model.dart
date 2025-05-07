class CategoryList {
  int id;
  String name;
  String imageUrl;
  String uniqueIdentifier;
  bool isNew;
  int appOrder;
  List<ServiceList> services;

  CategoryList({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.uniqueIdentifier,
    required this.isNew,
    required this.appOrder,
    required this.services,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        uniqueIdentifier: json["uniqueIdentifier"],
        isNew: json["isNew"],
        appOrder: json["appOrder"],
        services: List<ServiceList>.from(json["services"]
            .map((x) => ServiceList.fromJson(Map<String, dynamic>.from(x)))),
      );

  CategoryList copyWith(List<ServiceList> updatedValues) => CategoryList(
        id: id,
        name: name,
        imageUrl: imageUrl,
        uniqueIdentifier: uniqueIdentifier,
        isNew: isNew,
        appOrder: appOrder,
        services: updatedValues,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "uniqueIdentifier": uniqueIdentifier,
        "isNew": isNew,
        "appOrder": appOrder,
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
      };
}

class ServiceList {
  int id;
  Url url;
  String uniqueIdentifier;
  String service;
  Status status;
  String labelName;
  String? labelMaxLength;
  String? labelMinLength;
  String labelSample;
  String labelPrefix;
  String instructions;
  bool fixedlabelSize;
  bool priceInput;
  String? notificationUrl;
  double minValue;
  double maxValue;
  String? icon;
  int categoryId;
  String serviceCategoryName;
  bool webView;
  bool isNew;
  int appOrder;
  bool isSmsMode;
  String? labelSize;
  String? priceRange;
  String? cashBackView;

  ServiceList({
    required this.id,
    required this.url,
    required this.uniqueIdentifier,
    required this.service,
    required this.status,
    required this.labelName,
    this.labelMaxLength,
    this.labelMinLength,
    required this.labelSample,
    required this.labelPrefix,
    required this.instructions,
    required this.fixedlabelSize,
    required this.priceInput,
    this.notificationUrl,
    required this.minValue,
    required this.maxValue,
    this.icon,
    required this.categoryId,
    required this.serviceCategoryName,
    required this.webView,
    required this.isNew,
    required this.appOrder,
    required this.isSmsMode,
    this.labelSize,
    this.priceRange,
    this.cashBackView,
  });

  factory ServiceList.fromJson(Map<String, dynamic> json) => ServiceList(
        id: json["id"],
        url: urlValues.map[json["url"]]!,
        uniqueIdentifier: json["uniqueIdentifier"],
        service: json["service"],
        status: statusValues.map[json["status"]]!,
        labelName: json["labelName"] ?? "",
        labelMaxLength: json["labelMaxLength"],
        labelMinLength: json["labelMinLength"],
        labelSample: json["labelSample"] ?? "",
        labelPrefix: json["labelPrefix"] ?? "",
        instructions: json["instructions"],
        fixedlabelSize: json["fixedlabelSize"],
        priceInput: json["priceInput"],
        notificationUrl: json["notificationUrl"],
        minValue: json["minValue"] ?? 0.0,
        maxValue: json["maxValue"] ?? 0.0,
        icon: json["icon"],
        categoryId: json["categoryId"],
        serviceCategoryName: json["serviceCategoryName"],
        webView: json["webView"],
        isNew: json["isNew"],
        appOrder: json["appOrder"],
        isSmsMode: json["isSmsMode"],
        labelSize: json["labelSize"],
        priceRange: json["priceRange"],
        cashBackView: json["cashBackView"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": urlValues.reverse[url],
        "uniqueIdentifier": uniqueIdentifier,
        "service": service,
        "status": statusValues.reverse[status],
        "labelName": labelName,
        "labelMaxLength": labelMaxLength,
        "labelMinLength": labelMinLength,
        "labelSample": labelSample,
        "labelPrefix": labelPrefix,
        "instructions": instructions,
        "fixedlabelSize": fixedlabelSize,
        "priceInput": priceInput,
        "notificationUrl": notificationUrl,
        "minValue": minValue,
        "maxValue": maxValue,
        "icon": icon,
        "categoryId": categoryId,
        "serviceCategoryName": serviceCategoryName,
        "webView": webView,
        "isNew": isNew,
        "appOrder": appOrder,
        "isSmsMode": isSmsMode,
        "labelSize": labelSize,
        "priceRange": priceRange,
        "cashBackView": cashBackView,
      };
}

enum Status { ACTIVE }

final statusValues = EnumValues({"Active": Status.ACTIVE});

enum Url { GENERAL_MERCHANT_PAYMENT, URL, URL_URL }

final urlValues = EnumValues({
  "generalMerchantPayment": Url.GENERAL_MERCHANT_PAYMENT,
  "url": Url.URL,
  "URL": Url.URL_URL
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
