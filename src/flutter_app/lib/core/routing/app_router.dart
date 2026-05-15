import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/screens/group_chat_screen.dart';
import '../../features/groups/domain/group_models.dart';
import '../../features/draw/presentation/screens/managed_assignments_screen.dart';
import '../../features/draw/presentation/screens/my_assignment_screen.dart';
import '../../features/groups/presentation/screens/create_group_screen.dart';
import '../../features/groups/presentation/screens/dynamics_selector_screen.dart';
import '../../features/groups/presentation/screens/group_detail_screen.dart';
import '../../features/groups/presentation/screens/groups_home_screen.dart';
import '../../features/groups/presentation/screens/join_by_code_screen.dart';
import '../../features/raffle/presentation/screens/create_raffle_wizard_screen.dart';
import '../../features/teams/presentation/screens/create_duels_wizard_screen.dart';
import '../../features/teams/presentation/screens/create_pairings_wizard_screen.dart';
import '../../features/teams/presentation/screens/create_teams_wizard_screen.dart';
import '../../features/about/presentation/about_tarci_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/wishlist/presentation/screens/wishlist_edit_screen.dart';

class GroupDetailRouteExtra {
  const GroupDetailRouteExtra({this.inviteCode});

  final String? inviteCode;
}

class AppRoutes {
  static const splash = '/';
  static const groupsHome = '/groups';
  static const about = '/about';
  static const createGroup = '/groups/create';
  static const dynamicsSelect = '/groups/dynamics';
  static const createRaffle = '/groups/dynamics/raffle/create';
  static const createTeams = '/groups/dynamics/teams/create';
  static const createPairings = '/groups/dynamics/pairings/create';
  static const createDuels = '/groups/dynamics/duels/create';
  static const joinByCode = '/groups/join';
  static const groupDetail = '/groups/:groupId';
  static const myAssignment = '/groups/:groupId/executions/:executionId/my-assignment';
  static const managedAssignments = '/groups/:groupId/executions/:executionId/managed-assignments';
  static const wishlistEdit = '/groups/:groupId/wishlist/:participantId/edit';
  static const groupChat = '/groups/:groupId/chat';

  static String groupChatFor(String groupId) => '/groups/$groupId/chat';

  static String groupDetailFor(String groupId) => '/groups/$groupId';
}

GoRouter buildRouter({GlobalKey<NavigatorState>? navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
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
        path: AppRoutes.about,
        builder: (context, state) => const AboutTarciScreen(),
      ),
      GoRoute(
        path: AppRoutes.createGroup,
        builder: (context, state) => const CreateGroupScreen(),
      ),
      GoRoute(
        path: AppRoutes.dynamicsSelect,
        builder: (context, state) => const DynamicsSelectorScreen(),
      ),
      GoRoute(
        path: AppRoutes.createRaffle,
        builder: (context, state) => const CreateRaffleWizardScreen(),
      ),
      GoRoute(
        path: AppRoutes.createTeams,
        builder: (context, state) => const CreateTeamsWizardScreen(),
      ),
      GoRoute(
        path: AppRoutes.createPairings,
        builder: (context, state) => const CreatePairingsWizardScreen(),
      ),
      GoRoute(
        path: AppRoutes.createDuels,
        builder: (context, state) => const CreateDuelsWizardScreen(),
      ),
      GoRoute(
        path: AppRoutes.joinByCode,
        builder: (context, state) => const JoinByCodeScreen(),
      ),
      GoRoute(
        path: AppRoutes.groupChat,
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          final extra = state.extra as GroupChatRouteExtra?;
          return GroupChatScreen(
            groupId: groupId,
            groupName: extra?.groupName ?? '',
            eventDate: extra?.eventDate,
            drawCompleted: extra?.drawCompleted ?? false,
            teamsCompleted: extra?.teamsCompleted ?? false,
            teamsPreset: extra?.teamsPreset ?? TeamsPreset.standard,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.groupDetail,
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          final extra = state.extra as GroupDetailRouteExtra?;
          return GroupDetailScreen(
            groupId: groupId,
            initialInviteCode: extra?.inviteCode,
          );
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
      GoRoute(
        path: AppRoutes.wishlistEdit,
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          final participantId = state.pathParameters['participantId']!;
          final extra = state.extra as WishlistRouteExtra?;
          return WishlistEditScreen(
            groupId: groupId,
            participantId: participantId,
            subjectDisplayName: extra?.subjectDisplayName,
            readOnly: extra?.readOnly ?? false,
          );
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

