import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/view/chats/chat_room_page.dart';
import 'package:whats_clone/view/chats/chats_page.dart';
import 'package:whats_clone/view/contacts/contacts_page.dart';
import 'package:whats_clone/view/login/login_page.dart';
import 'package:whats_clone/view/onboarding/onboarding_page.dart';
import 'package:whats_clone/view/profile/pages/create_profile_page.dart';
import 'package:whats_clone/view/splash/splash_page.dart';
import 'package:whats_clone/view/widgets/loading_wrapper.dart';
import 'package:whats_clone/view/widgets/navigation_wrapper.dart';

final appRouter = GoRouter(
  initialLocation: '/${RouteName.splash}',
  routes: [
    GoRoute(
      path: '/${RouteName.splash}',
      name: RouteName.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/${RouteName.onboarding}',
      name: RouteName.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/${RouteName.login}',
      name: RouteName.login,
      builder: (context, state) => const LoadingWrapper(child: LoginPage()),
    ),
    GoRoute(
      path: '/${RouteName.createProfile}',
      name: RouteName.createProfile,
      builder: (context, state) =>
          const LoadingWrapper(child: CreateProfilePage()),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          NavigationWrapper(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: contactsKey,
          routes: [
            GoRoute(
              path: '/${RouteName.contacts}',
              name: RouteName.contacts,
              builder: (context, state) => const ContactPage(),
            )
          ],
        ),
        StatefulShellBranch(
          navigatorKey: chatKey,
          routes: [
            GoRoute(
              path: '/${RouteName.chats}',
              name: RouteName.chats,
              builder: (context, state) => const ChatsPage(),
              routes: [
                GoRoute(
                  path: RouteName.chatRoom,
                  name: RouteName.chatRoom,
                  builder: (context, state) {
                    final chatProfile = state.extra as ChatProfile;
                    return ChatRoomPage(
                      chatProfile: chatProfile,
                    );
                  },
                )
              ],
            )
          ],
        ),
        StatefulShellBranch(
          navigatorKey: moreKey,
          routes: [
            GoRoute(
              path: '/${RouteName.more}',
              name: RouteName.more,
              builder: (context, state) => const Text('more'),
            )
          ],
        ),
      ],
    ),
  ],
);

final contactsKey = GlobalKey<NavigatorState>();
final chatKey = GlobalKey<NavigatorState>();
final moreKey = GlobalKey<NavigatorState>();
