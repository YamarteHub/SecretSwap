import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/draw/presentation/screens/managed_assignments_screen.dart';
import '../../features/draw/presentation/screens/my_assignment_screen.dart';
import '../../features/groups/presentation/screens/create_group_screen.dart';
import '../../features/groups/presentation/screens/group_detail_screen.dart';
import '../../features/groups/presentation/screens/groups_home_screen.dart';
import '../../features/groups/presentation/screens/join_by_code_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const groupsHome = '/groups';
  static const createGroup = '/groups/create';
  static const joinByCode = '/groups/join';
  static const groupDetail = '/groups/:groupId';
  static const myAssignment = '/groups/:groupId/executions/:executionId/my-assignment';
  static const managedAssignments = '/groups/:groupId/executions/:executionId/managed-assignments';
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.groupsHome,
        builder: (context, state) => const GroupsHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.createGroup,
        builder: (context, state) => const CreateGroupScreen(),
      ),
      GoRoute(
        path: AppRoutes.joinByCode,
        builder: (context, state) => const JoinByCodeScreen(),
      ),
      GoRoute(
        path: AppRoutes.groupDetail,
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          return GroupDetailScreen(groupId: groupId);
        },
      ),
      GoRoute(
        path: AppRoutes.myAssignment,
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          final executionId = state.pathParameters['executionId']!;
          return MyAssignmentScreen(groupId: groupId, executionId: executionId);
        },
      ),
      GoRoute(
        path: AppRoutes.managedAssignments,
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          final executionId = state.pathParameters['executionId']!;
          return ManagedAssignmentsScreen(groupId: groupId, executionId: executionId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(state.error?.toString() ?? 'Unknown routing error'),
      ),
    ),
  );
}

