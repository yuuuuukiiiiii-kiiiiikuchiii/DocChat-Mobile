

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';

enum OnbStatus { unknown, needed, done }
enum AuthStatus { unknown, authenticated, unauthenticated }

final onbStatusProvider = StateProvider<OnbStatus>((_) => OnbStatus.unknown);
final authStatusProvider = StateProvider<AuthStatus>((_) => AuthStatus.unknown);
final bootErrorProvider = StateProvider<CustomError?>((_) => null);

final sessionExpiredProvider = StateProvider<bool>((ref) => false);
