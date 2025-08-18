

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'local_storage_provider.g.dart';

@riverpod
LocalStorage localStorage(Ref ref) {
  return LocalStorage();
}