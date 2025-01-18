import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/view/widgets/app_navigation_bar.dart';

class NavigationWrapper extends StatelessWidget {
  const NavigationWrapper({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).state?.path;

    // Determine if the bottom navigation bar should be hidden
    final hideBottomNav = location?.contains(RouteName.chatRoom) ?? false;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: hideBottomNav
          ? null
          : AppNavigationBar(
              navigationShell: navigationShell,
              navigationDestinations: destinations,
            ),
    );
  }
}
