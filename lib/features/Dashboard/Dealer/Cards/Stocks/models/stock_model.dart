class StockResponse {
  final bool success;
  final List<StockDetail> stockDetails;

  StockResponse({
    required this.success,
    required this.stockDetails,
  });

  factory StockResponse.fromJson(Map<String, dynamic> json) {
    return StockResponse(
      success: json['success'] ?? false,
      stockDetails: (json['stockDetails'] as List<dynamic>?)
              ?.map((item) => StockDetail.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class StockDetail {
  final int itemId;
  final Item item;
  final int warehouseId;
  final Warehouse warehouse;
  final String? batch;
  final int openingStock;
  final double? openingStockRate;
  final String? manufacturingDate;
  final String? expiryDate;
  final double? salesRate;
  final double? newSalesRate;
  final String? newSalesRateApplicableDate;
  final double? purchaseRate;
  final double? newPurchaseRate;
  final String? newPurchaseRateApplicableDate;
  final double? landingCost;
  final double? specialRate;
  final double? specialRate2;
  final double? wholesaleRate;
  final int currentStock;
  final int pendingPackageQuantity;
  final double? closingStockRate;
  final String? rack;
  final String? row;
  final int? branchId;
  final String? branch;
  final int referenceId;
  final String? referenceType;
  final int companyId;
  final String? company;
  final int id;
  final String mainId;
  final bool isDeleted;
  final String createdDate;
  final String updatedDate;
  final String? createdBy;

  StockDetail({
    required this.itemId,
    required this.item,
    required this.warehouseId,
    required this.warehouse,
    this.batch,
    required this.openingStock,
    this.openingStockRate,
    this.manufacturingDate,
    this.expiryDate,
    this.salesRate,
    this.newSalesRate,
    this.newSalesRateApplicableDate,
    this.purchaseRate,
    this.newPurchaseRate,
    this.newPurchaseRateApplicableDate,
    this.landingCost,
    this.specialRate,
    this.specialRate2,
    this.wholesaleRate,
    required this.currentStock,
    required this.pendingPackageQuantity,
    this.closingStockRate,
    this.rack,
    this.row,
    this.branchId,
    this.branch,
    required this.referenceId,
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

  factory StockDetail.fromJson(Map<String, dynamic> json) {
    return StockDetail(
      itemId: (json['itemId'] ?? 0).toInt(),
      item: Item.fromJson(json['item'] ?? {}),
      warehouseId: (json['warehouseId'] ?? 0).toInt(),
      warehouse: Warehouse.fromJson(json['warehouse'] ?? {}),
      batch: json['batch'],
      openingStock: (json['openingStock'] ?? 0).toInt(),
      openingStockRate: json['openingStockRate']?.toDouble(),
      manufacturingDate: json['manufacturingDate'],
      expiryDate: json['expiryDate'],
      salesRate: json['salesRate']?.toDouble(),
      newSalesRate: json['newSalesRate']?.toDouble(),
      newSalesRateApplicableDate: json['newSalesRateApplicableDate'],
      purchaseRate: json['purchaseRate']?.toDouble(),
      newPurchaseRate: json['newPurchaseRate']?.toDouble(),
      newPurchaseRateApplicableDate: json['newPurchaseRateApplicableDate'],
      landingCost: json['landingCost']?.toDouble(),
      specialRate: json['specialRate']?.toDouble(),
      specialRate2: json['specialRate2']?.toDouble(),
      wholesaleRate: json['wholesaleRate']?.toDouble(),
      currentStock: (json['currentStock'] ?? 0).toInt(),
      pendingPackageQuantity: (json['pendingPackageQuantity'] ?? 0).toInt(),
      closingStockRate: json['closingStockRate']?.toDouble(),
      rack: json['rack'],
      row: json['row'],
      branchId: json['branchId']?.toInt(),
      branch: json['branch'],
      referenceId: (json['referenceId'] ?? 0).toInt(),
      referenceType: json['referenceType'],
      companyId: (json['companyId'] ?? 0).toInt(),
      company: json['company'],
      id: (json['id'] ?? 0).toInt(),
      mainId: json['mainId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      createdBy: json['createdBy'],
    );
  }
}

class Item {
  final String name;
  final String? barcode;
  final int? categoryId;
  final String? category;
  final int? subCategoryId;
  final String? subCategory;
  final String? make;
  final String? country;
  final int? brandId;
  final String? brand;
  final int? itemGroupId;
  final String? itemGroup;
  final int? hsnCodeId;
  final String? hsnCode;
  final int? taxId;
  final String? tax;
  final int? skuId;
  final String? sku;
  final double? salesRate;
  final String? salesRateApplicableDate;
  final double? purchaseRate;
  final String? purchaseRateApplicableDate;
  final double? landingCost;
  final double? specialRate;
  final double? specialRate2;
  final int? manufacturerId;
  final String? manufacturer;
  final String? image;
  final String? description;
  final String? unit;
  final String? denomination;
  final String? convertion;
  final bool maintainBatch;
  final bool useManufacturingDate;
  final bool useExpiry;
  final bool isGstApplicable;
  final String? hsn;
  final String? hsnDescription;
  final double? gstRate;
  final double? cessRate;
  final String typeOfSupply;
  final String? reportingUQC;
  final double? mrp;
  final String? mrpApplicableFrom;
  final double? standardCost;
  final String? standardCostApplicableFrom;
  final double? standardSellRate;
  final String? standardSellRateApplicableFrom;
  final int referenceId;
  final String referenceType;
  final int companyId;
  final String? company;
  final int id;
  final String mainId;
  final bool isDeleted;
  final String createdDate;
  final String updatedDate;
  final String? createdBy;

  Item({
    required this.name,
    this.barcode,
    this.categoryId,
    this.category,
    this.subCategoryId,
    this.subCategory,
    this.make,
    this.country,
    this.brandId,
    this.brand,
    this.itemGroupId,
    this.itemGroup,
    this.hsnCodeId,
    this.hsnCode,
    this.taxId,
    this.tax,
    this.skuId,
    this.sku,
    this.salesRate,
    this.salesRateApplicableDate,
    this.purchaseRate,
    this.purchaseRateApplicableDate,
    this.landingCost,
    this.specialRate,
    this.specialRate2,
    this.manufacturerId,
    this.manufacturer,
    this.image,
    this.description,
    this.unit,
    this.denomination,
    this.convertion,
    required this.maintainBatch,
    required this.useManufacturingDate,
    required this.useExpiry,
    required this.isGstApplicable,
    this.hsn,
    this.hsnDescription,
    this.gstRate,
    this.cessRate,
    required this.typeOfSupply,
    this.reportingUQC,
    this.mrp,
    this.mrpApplicableFrom,
    this.standardCost,
    this.standardCostApplicableFrom,
    this.standardSellRate,
    this.standardSellRateApplicableFrom,
    required this.referenceId,
    required this.referenceType,
    required this.companyId,
    this.company,
    required this.id,
    required this.mainId,
    required this.isDeleted,
    required this.createdDate,
    required this.updatedDate,
    this.createdBy,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? '',
      barcode: json['barcode'],
      categoryId: json['categoryId']?.toInt(),
      category: json['category'],
      subCategoryId: json['subCategoryId']?.toInt(),
      subCategory: json['subCategory'],
      make: json['make'],
      country: json['country'],
      brandId: json['brandId']?.toInt(),
      brand: json['brand'],
      itemGroupId: json['itemGroupId']?.toInt(),
      itemGroup: json['itemGroup'],
      hsnCodeId: json['hsnCodeId']?.toInt(),
      hsnCode: json['hsnCode'],
      taxId: json['taxId']?.toInt(),
      tax: json['tax'],
      skuId: json['skuId']?.toInt(),
      sku: json['sku'],
      salesRate: json['salesRate']?.toDouble(),
      salesRateApplicableDate: json['salesRateApplicableDate'],
      purchaseRate: json['purchaseRate']?.toDouble(),
      purchaseRateApplicableDate: json['purchaseRateApplicableDate'],
      landingCost: json['landingCost']?.toDouble(),
      specialRate: json['specialRate']?.toDouble(),
      specialRate2: json['specialRate2']?.toDouble(),
      manufacturerId: json['manufacturerId']?.toInt(),
      manufacturer: json['manufacturer'],
      image: json['image'],
      description: json['description'],
      unit: json['unit'],
      denomination: json['denomination'],
      convertion: json['convertion'],
      maintainBatch: json['maintainBatch'] ?? false,
      useManufacturingDate: json['useManufacturingDate'] ?? false,
      useExpiry: json['useExpiry'] ?? false,
      isGstApplicable: json['isGstApplicable'] ?? false,
      hsn: json['hsn'],
      hsnDescription: json['hsnDescription'],
      gstRate: json['gstRate']?.toDouble(),
      cessRate: json['cessRate']?.toDouble(),
      typeOfSupply: json['typeOfSupply'] ?? '',
      reportingUQC: json['reportingUQC'],
      mrp: json['mrp']?.toDouble(),
      mrpApplicableFrom: json['mrpApplicableFrom'],
      standardCost: json['standardCost']?.toDouble(),
      standardCostApplicableFrom: json['standardCostApplicableFrom'],
      standardSellRate: json['standardSellRate']?.toDouble(),
      standardSellRateApplicableFrom: json['standardSellRateApplicableFrom'],
      referenceId: (json['referenceId'] ?? 0).toInt(),
      referenceType: json['referenceType'] ?? '',
      companyId: (json['companyId'] ?? 0).toInt(),
      company: json['company'],
      id: (json['id'] ?? 0).toInt(),
      mainId: json['mainId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      createdBy: json['createdBy'],
    );
  }
}

class Warehouse {
  final String name;
  final String? code;
  final String? address;
  final String? address2;
  final String? city;
  final int? countryId;
  final String? country;
  final int? stateId;
  final String? state;
  final int? branchId;
  final String? branch;
  final String? pinCode;
  final String? contactPerson;
  final String? contactNumber;
  final int? employeeId;
  final String? employee;
  final int referenceId;
  final String referenceType;
  final int companyId;
  final String? company;
  final int id;
  final String mainId;
  final bool isDeleted;
  final String createdDate;
  final String updatedDate;
  final String? createdBy;

  Warehouse({
    required this.name,
    this.code,
    this.address,
    this.address2,
    this.city,
    this.countryId,
    this.country,
    this.stateId,
    this.state,
    this.branchId,
    this.branch,
    this.pinCode,
    this.contactPerson,
    this.contactNumber,
    this.employeeId,
    this.employee,
    required this.referenceId,
    required this.referenceType,
    required this.companyId,
    this.company,
    required this.id,
    required this.mainId,
    required this.isDeleted,
    required this.createdDate,
    required this.updatedDate,
    this.createdBy,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      name: json['name'] ?? '',
      code: json['code'],
      address: json['address'],
      address2: json['address2'],
      city: json['city'],
      countryId: json['countryId']?.toInt(),
      country: json['country'],
      stateId: json['stateId']?.toInt(),
      state: json['state'],
      branchId: json['branchId']?.toInt(),
      branch: json['branch'],
      pinCode: json['pinCode'],
      contactPerson: json['contactPerson'],
      contactNumber: json['contactNumber'],
      employeeId: json['employeeId']?.toInt(),
      employee: json['employee'],
      referenceId: (json['referenceId'] ?? 0).toInt(),
      referenceType: json['referenceType'] ?? '',
      companyId: (json['companyId'] ?? 0).toInt(),
      company: json['company'],
      id: (json['id'] ?? 0).toInt(),
      mainId: json['mainId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      createdBy: json['createdBy'],
    );
  }
}