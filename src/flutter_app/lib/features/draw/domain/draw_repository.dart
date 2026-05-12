import 'draw_models.dart';

abstract interface class DrawRepository {
  Future<String> executeDraw({
    required String groupId,
    required String idempotencyKey,
  });

  Future<MyAssignment> getMyAssignment({
    required String groupId,
    required String executionId,
  });

  Future<List<ManagedAssignment>> getManagedAssignments({
    required String groupId,
    required String executionId,
  });
}

