import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/view/widgets/app_navigation_bar.dart';


const List<String> hideRoutes = [RouteName.chatRoom,RouteName.updateProfile];
class NavigationWrapper extends StatelessWidget {
  const NavigationWrapper({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).state?.name;

    // Determine if the bottom navigation bar should be hidden
    final hideBottomNav = hideRoutes.contains(location) ;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: hideBottomNav
          ? null
          : AppNavigationBar(
              navigationShell: navigationShell,
              navigationDestinations: destinations(context),
            ),
    );
  }
}
