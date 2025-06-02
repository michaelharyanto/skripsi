class voucher {
  String voucher_id;
  int voucher_value;
  int minimum;
  
  voucher(
      {required this.voucher_id,
      required this.voucher_value,
      required this.minimum});

  factory voucher.fromJson(Map<String, dynamic> json) {
    return voucher(
      voucher_id: json['voucher_id'],
      voucher_value: json['voucher_value'],
      minimum: json['minimum'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voucher_id': voucher_id,
      'voucher_value': voucher_value,
      'minimum': minimum,
    };
  }
}
