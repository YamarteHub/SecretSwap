import '../domain/draw_models.dart';
import '../domain/draw_repository.dart';

class DrawRepositoryStub implements DrawRepository {
  @override
  Future<String> executeDraw({required String groupId, required String idempotencyKey}) async {
    throw UnimplementedError('executeDraw not wired yet');
  }

  @override
  Future<MyAssignment> getMyAssignment({required String groupId, required String executionId}) async {
    throw UnimplementedError('getMyAssignment not wired yet');
  }

  @override
  Future<List<ManagedAssignment>> getManagedAssignments({
    required String groupId,
    required String executionId,
  }) async {
    throw UnimplementedError('getManagedAssignments not wired yet');
  }
}

