import 'package:dio/dio.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/profile/profile.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';

class ProfileRepository {
  final AuthenticatedDioClient client;

  ProfileRepository({required this.client});

  Future<Profile> getProfile() async {
    try {
      final response = await client.dio.get(
        "/profile",
        options: Options(contentType: "application/json"),
      );

      if (response.statusCode == 200) {
        // print(response.data["created_at"]);
        return Profile.fromJson(response.data);
      } else {
        throw HttpErrorException(
          message: (response.data["error"]).toString(),
          statusCode: response.statusCode!,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
