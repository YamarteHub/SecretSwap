import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/draw_repository_impl.dart';
import '../domain/draw_repository.dart';

final drawRepositoryProvider = Provider<DrawRepository>((ref) {
  return DrawRepositoryImpl();
});
