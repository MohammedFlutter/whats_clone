import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/view/widgets/app_navigation_bar.dart';

class NavigationWrapper extends StatelessWidget {
  const NavigationWrapper({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppNavigationBar(
        navigationShell: navigationShell,
        navigationDestinations: destinations,
      ),
    );
  }
}
