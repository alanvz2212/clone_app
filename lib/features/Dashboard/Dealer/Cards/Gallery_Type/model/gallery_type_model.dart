class GalleryTypeResponse {
  final bool success;
  final String message;
  final List<GalleryType> data;
  final dynamic additionalData;

  GalleryTypeResponse({
    required this.success,
    required this.message,
    required this.data,
    this.additionalData,
  });

  factory GalleryTypeResponse.fromJson(Map<String, dynamic> json) {
    return GalleryTypeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => GalleryType.fromJson(item))
              .toList() ??
          [],
      additionalData: json['additionalData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
      'additionalData': additionalData,
    };
  }
}

class GalleryType {
  final String name;
  final String icon;
  final dynamic referenceId;
  final dynamic referenceType;
  final int companyId;
  final Company? company;
  final int id;
  final String mainId;
  final bool isDeleted;
  final String createdDate;
  final String updatedDate;
  final dynamic createdBy;

  GalleryType({
    required this.name,
    required this.icon,
    this.referenceId,
    this.referenceType,
    required this.companyId,
    this.company,
    required this.id,
    required this.mainId,
    required this.isDeleted,
    required this.createdDate,
    required this.updatedDate,
    this.createdBy,
  });

  factory GalleryType.fromJson(Map<String, dynamic> json) {
    return GalleryType(
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      referenceId: json['referenceId'],
      referenceType: json['referenceType'],
      companyId: json['companyId'] ?? 0,
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
      id: json['id'] ?? 0,
      mainId: json['mainId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'referenceId': referenceId,
      'referenceType': referenceType,
      'companyId': companyId,
      'company': company?.toJson(),
      'id': id,
      'mainId': mainId,
      'isDeleted': isDeleted,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'createdBy': createdBy,
    };
  }
}

class Company {
  final String companyName;
  final int countryId;
  final dynamic country;
  final int stateId;
  final dynamic state;
  final int currencyId;
  final dynamic currency;
  final String phoneNumber;
  final String logo;
  final int addressId;
  final dynamic address;
  final int id;
  final String mainId;
  final bool isDeleted;
  final String createdDate;
  final String updatedDate;
  final dynamic createdBy;

  Company({
    required this.companyName,
    required this.countryId,
    this.country,
    required this.stateId,
    this.state,
    required this.currencyId,
    this.currency,
    required this.phoneNumber,
    required this.logo,
    required this.addressId,
    this.address,
    required this.id,
    required this.mainId,
    required this.isDeleted,
    required this.createdDate,
    required this.updatedDate,
    this.createdBy,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyName: json['companyName'] ?? '',
      countryId: json['countryId'] ?? 0,
      country: json['country'],
      stateId: json['stateId'] ?? 0,
      state: json['state'],
      currencyId: json['currencyId'] ?? 0,
      currency: json['currency'],
      phoneNumber: json['phoneNumber'] ?? '',
      logo: json['logo'] ?? '',
      addressId: json['addressId'] ?? 0,
      address: json['address'],
      id: json['id'] ?? 0,
      mainId: json['mainId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'countryId': countryId,
      'country': country,
      'stateId': stateId,
      'state': state,
      'currencyId': currencyId,
      'currency': currency,
      'phoneNumber': phoneNumber,
      'logo': logo,
      'addressId': addressId,
      'address': address,
      'id': id,
      'mainId': mainId,
      'isDeleted': isDeleted,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'createdBy': createdBy,
    };
  }
}
