import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/models/profile/profile.dart';
import 'package:rag_faq_document/repository/handle_exception.dart';
import 'package:rag_faq_document/repository/profile/profile_repository.dart';
import 'package:rag_faq_document/utils/utils.dart';

class ProfileService {
  final ProfileRepository repo;
  ProfileService({required this.repo});

  Future<Profile> getProfile() async {
    try {
      return await repo.getProfile();
    } on HttpErrorException catch (e) {
      final userMessage = mapHttpErrorToUserMessage(e.message, e.statusCode);
      throw CustomError.server(
        statusCode: e.statusCode,
        message: e.message,
        userMessage: userMessage,
      );
    } catch (e) {
      throw handleException(e);
    }
  }
}
