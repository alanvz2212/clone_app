import 'package:equatable/equatable.dart';

class SearchItemRequest extends Equatable {
  final String search;

  const SearchItemRequest({required this.search});

  Map<String, dynamic> toJson() {
    return {'Search': search};
  }

  @override
  List<Object> get props => [search];
}

class SearchItemResponse extends Equatable {
  final bool success;
  final List<SearchItem>? items;
  final String? error;

  const SearchItemResponse({required this.success, this.items, this.error});

  factory SearchItemResponse.fromJson(Map<String, dynamic> json) {
    try {
      return SearchItemResponse(
        success: true,
        items: (json['data'] as List?)
            ?.map((item) => SearchItem.fromJson(item))
            .toList(),
      );
    } catch (e) {
      return SearchItemResponse(success: false, error: e.toString());
    }
  }

  factory SearchItemResponse.failure({required String error}) {
    return SearchItemResponse(success: false, error: error);
  }

  @override
  List<Object?> get props => [success, items, error];
}

class SearchItem extends Equatable {
  final int? id;
  final String? name;
  final String? barcode;
  final String? description;
  final double? currentSalesPrice;
  final double? currentPurchasePrice;
  final String? unit;
  final ItemCategory? category;
  final ItemGroup? itemGroup;
  final Brand? brand;
  final Sku? sku;
  final Tax? tax;
  final HsnCode? hsnCode;
  final String? typeOfSupply;
  final bool? isGstApplicable;

  const SearchItem({
    this.id,
    this.name,
    this.barcode,
    this.description,
    this.currentSalesPrice,
    this.currentPurchasePrice,
    this.unit,
    this.category,
    this.itemGroup,
    this.brand,
    this.sku,
    this.tax,
    this.hsnCode,
    this.typeOfSupply,
    this.isGstApplicable,
  });

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      id: json['id'] as int?,
      name: json['name'] as String?,
      barcode: json['barcode'] as String?,
      description: json['description'] as String?,
      currentSalesPrice: (json['currentSalesPrice'] as num?)?.toDouble(),
      currentPurchasePrice: (json['currentPurchasePrice'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      category: json['category'] != null
          ? ItemCategory.fromJson(json['category'])
          : null,
      itemGroup: json['itemGroup'] != null
          ? ItemGroup.fromJson(json['itemGroup'])
          : null,
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      sku: json['sku'] != null ? Sku.fromJson(json['sku']) : null,
      tax: json['tax'] != null ? Tax.fromJson(json['tax']) : null,
      hsnCode: json['hsnCode'] != null
          ? HsnCode.fromJson(json['hsnCode'])
          : null,
      typeOfSupply: json['typeOfSupply'] as String?,
      isGstApplicable: json['isGstApplicable'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'description': description,
      'currentSalesPrice': currentSalesPrice,
      'currentPurchasePrice': currentPurchasePrice,
      'unit': unit,
      'category': category?.toJson(),
      'itemGroup': itemGroup?.toJson(),
      'brand': brand?.toJson(),
      'sku': sku?.toJson(),
      'tax': tax?.toJson(),
      'hsnCode': hsnCode?.toJson(),
      'typeOfSupply': typeOfSupply,
      'isGstApplicable': isGstApplicable,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    barcode,
    description,
    currentSalesPrice,
    currentPurchasePrice,
    unit,
    category,
    itemGroup,
    brand,
    sku,
    tax,
    hsnCode,
    typeOfSupply,
    isGstApplicable,
  ];
}

class ItemCategory extends Equatable {
  final int? id;
  final String? name;
  final int? parentId;

  const ItemCategory({this.id, this.name, this.parentId});

  factory ItemCategory.fromJson(Map<String, dynamic> json) {
    return ItemCategory(
      id: json['id'] as int?,
      name: json['name'] as String?,
      parentId: json['parentId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'parentId': parentId};
  }

  @override
  List<Object?> get props => [id, name, parentId];
}

class ItemGroup extends Equatable {
  final int? id;
  final String? name;
  final String? description;

  const ItemGroup({this.id, this.name, this.description});

  factory ItemGroup.fromJson(Map<String, dynamic> json) {
    return ItemGroup(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  @override
  List<Object?> get props => [id, name, description];
}

class Brand extends Equatable {
  final int? id;
  final String? name;

  const Brand({this.id, this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['id'] as int?, name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];
}

class Sku extends Equatable {
  final int? id;
  final String? name;
  final String? code;

  const Sku({this.id, this.name, this.code});

  factory Sku.fromJson(Map<String, dynamic> json) {
    return Sku(
      id: json['id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code};
  }

  @override
  List<Object?> get props => [id, name, code];
}

class Tax extends Equatable {
  final int? id;
  final double? percent;
  final double? cgst;
  final double? sgst;
  final String? description;

  const Tax({this.id, this.percent, this.cgst, this.sgst, this.description});

  factory Tax.fromJson(Map<String, dynamic> json) {
    return Tax(
      id: json['id'] as int?,
      percent: (json['percent'] as num?)?.toDouble(),
      cgst: (json['cgst'] as num?)?.toDouble(),
      sgst: (json['sgst'] as num?)?.toDouble(),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'percent': percent,
      'cgst': cgst,
      'sgst': sgst,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, percent, cgst, sgst, description];
}

class HsnCode extends Equatable {
  final int? id;
  final String? name;

  const HsnCode({this.id, this.name});

  factory HsnCode.fromJson(Map<String, dynamic> json) {
    return HsnCode(id: json['id'] as int?, name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];
}
