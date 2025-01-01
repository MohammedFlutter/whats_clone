import 'package:flutter/cupertino.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/view/widgets/loading_wrapper.dart';
import 'package:whats_clone/view/login/login_page.dart';
import 'package:whats_clone/view/onboarding/onboarding_page.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/view/profile/pages/create_profile_page.dart';
import 'package:whats_clone/view/splash/splash_page.dart';
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
              builder: (context, state) => const Text('Contacts'),
            )
          ],
        ),
        StatefulShellBranch(
          navigatorKey: chatKey,
          routes: [
            GoRoute(
              path: '/${RouteName.chats}',
              name: RouteName.chats,
              builder: (context, state) => const Text('chats'),
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

final chatKey = GlobalKey<NavigatorState>();
final contactsKey = GlobalKey<NavigatorState>();
final moreKey = GlobalKey<NavigatorState>();
