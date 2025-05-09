import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/core/routes/route_params.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/view/chats/chat_room_page.dart';
import 'package:whats_clone/view/chats/chats_page.dart';
import 'package:whats_clone/view/contacts/contacts_page.dart';
import 'package:whats_clone/view/login/login_page.dart';
import 'package:whats_clone/view/more/more_page.dart';
import 'package:whats_clone/view/onboarding/onboarding_page.dart';
import 'package:whats_clone/view/profile/pages/create_profile_page.dart';
import 'package:whats_clone/view/profile/pages/update_profile_page.dart';
import 'package:whats_clone/view/splash/splash_page.dart';
import 'package:whats_clone/view/widgets/app_wrapper.dart';
import 'package:whats_clone/view/widgets/loading_wrapper.dart';
import 'package:whats_clone/view/widgets/navigation_wrapper.dart';

final appRouter = GoRouter(
  initialLocation: '/${RouteName.splash}',
  navigatorKey: navigatorKey,
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
      builder: (context, state, navigationShell) => AppWrapper(
        child: NavigationWrapper(navigationShell: navigationShell),
      ),
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
                  path: '${RouteName.chatRoom}/:${RouteParams.chatId}',
                  name: RouteName.chatRoom,
                  builder: (context, state) {
                    final chatId = state.pathParameters[RouteParams.chatId]!;
                    return ChatRoomPage(
                      chatId: chatId,
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
              builder: (context, state) => const MorePage(),
              routes: [
                GoRoute(
                  path: RouteName.updateProfile,
                  name: RouteName.updateProfile,
                  builder: (context, state) {

                    final profile = state.extra as Profile;
                    return LoadingWrapper(child: UpdateProfilePage(profile: profile));
                  },
                ),
              ],
            )
          ],
        ),
      ],
    ),
  ],
);

final navigatorKey = GlobalKey<NavigatorState>();
final contactsKey = GlobalKey<NavigatorState>();
final chatKey = GlobalKey<NavigatorState>();
final moreKey = GlobalKey<NavigatorState>();
