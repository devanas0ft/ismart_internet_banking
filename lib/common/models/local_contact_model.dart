class LocalContact {
  String phone;
  String name;

  LocalContact({
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "name": name,
    };
  }
}
