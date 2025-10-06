import '../model/gallery_type_model.dart';
import '../../../../../../services/api_service.dart';
import '../../../../../../constants/api_endpoints.dart';

class GalleryService {
  final ApiService _apiService;

  GalleryService(this._apiService);

  Future<GalleryTypeResponse> getAllGalleryTypes() async {
    try {
      final response = await _apiService.getFullUrl<Map<String, dynamic>>(
        ApiEndpoints.gallery,
      );

      if (response.statusCode == 200 && response.data != null) {
        return GalleryTypeResponse.fromJson(response.data!);
      } else {
        throw Exception('Failed to load gallery types: ${response.statusCode}');
      }
    } on ApiException catch (e) {
      throw Exception('Error fetching gallery types: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching gallery types: $e');
    }
  }
}
