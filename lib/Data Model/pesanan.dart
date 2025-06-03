import 'package:skripsi/Data%20Model/menu.dart';

class pesanan {
  DateTime created;
  String lastStatus;
  String order_id;
  List<cart> detail;
  String tenant_id;
  String tenant_name;
  bool voucherApplied;
  String? voucher_id;
  int? voucher_value;
  String user_id;
  String user_name;
  String user_email;
  pesanan({
    required this.created,
    required this.lastStatus,
    required this.order_id,
    required this.detail,
    required this.tenant_id,
    required this.tenant_name,
    required this.voucherApplied,
    this.voucher_id,
    this.voucher_value,
    required this.user_id,
    required this.user_name,
    required this.user_email,
  });
}

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
