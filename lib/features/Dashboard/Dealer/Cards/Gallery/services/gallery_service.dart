import '../model/gallery_document_model.dart';
import '../../../../../../services/api_service.dart';
import '../../../../../../constants/api_endpoints.dart';

class GalleryDocumentService {
  final ApiService _apiService;

  GalleryDocumentService(this._apiService);

  Future<GalleryDocumentResponse> getGalleryDocuments(int id) async {
    try {
      final response = await _apiService.getFullUrl<Map<String, dynamic>>(
        ApiEndpoints.galleryDocuments(id),
      );

      if (response.statusCode == 200 && response.data != null) {
        return GalleryDocumentResponse.fromJson(response.data!);
      } else {
        throw Exception(
          'Failed to load gallery documents: ${response.statusCode}',
        );
      }
    } on ApiException catch (e) {
      throw Exception('Error fetching gallery documents: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching gallery documents: $e');
    }
  }
}
