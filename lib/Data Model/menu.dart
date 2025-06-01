import 'package:get/get.dart';

class menu {
  String? menu_id;
  String? menu_name;
  String? menu_desc;
  String? menu_image;
  int? menu_price;
  int? menu_stock;
  RxBool? isActive;
  double? averageRating;
  String? tenant_id;

  menu(
      {this.menu_id,
      this.menu_name,
      this.menu_desc,
      this.menu_image,
      this.menu_price,
      this.menu_stock,
      this.isActive,
      this.averageRating,
      this.tenant_id});

  factory menu.fromJson(Map<String, dynamic> json) {
    return menu(
      menu_id: json['menu_id'],
      menu_name: json['menu_name'],
      menu_desc: json['menu_desc'],
      menu_image: json['menu_image'],
      menu_price: json['menu_price'],
      menu_stock: json['menu_stock'],
      isActive: RxBool(json['isActive'] ?? false),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      tenant_id: json['tenant_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_id': menu_id,
      'menu_name': menu_name,
      'menu_desc': menu_desc,
      'menu_image': menu_image,
      'menu_price': menu_price,
      'menu_stock': menu_stock,
      'isActive': isActive?.value,
      'averageRating': averageRating,
      'tenant_id': tenant_id,
    };
  }
}

class cart {
  String menu_id;
  String tenant_id;
  String tenant_name;
  int? menu_stock;
  int? menu_price;
  RxBool checked;
  int quantity;
  RxBool? isActive;
  String notes;
  String status;
  menu? currentMenu;
  cart({
    required this.menu_id,
    required this.tenant_id,
    required this.tenant_name,
    required this.checked,
    required this.quantity,
    this.isActive,
    this.menu_stock,
    this.menu_price,
    required this.notes,
    required this.status,
    this.currentMenu
  });
}

class cartList {
  List<cart> foodList;
  RxBool checked;
  String tenant_name;
  cartList({
    required this.foodList,
    required this.checked,
    required this.tenant_name
  });
}
