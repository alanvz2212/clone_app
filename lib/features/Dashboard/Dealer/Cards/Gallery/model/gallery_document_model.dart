class GalleryDocumentResponse {
  final bool success;
  final List<GalleryDocument> data;

  GalleryDocumentResponse({
    required this.success,
    required this.data,
  });

  factory GalleryDocumentResponse.fromJson(Map<String, dynamic> json) {
    return GalleryDocumentResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => GalleryDocument.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class GalleryDocument {
  final String title;
  final String fileName;

  GalleryDocument({
    required this.title,
    required this.fileName,
  });

  factory GalleryDocument.fromJson(Map<String, dynamic> json) {
    return GalleryDocument(
      title: json['title'] ?? '',
      fileName: json['fileName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fileName': fileName,
    };
  }

  String get fullImageUrl => 'https://tmsapi.abm4trades.com/$fileName';
}
