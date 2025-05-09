import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/core/theme/app_colors.dart';
import 'package:whats_clone/view/constants/icons_assets.dart';
import 'package:whats_clone/view/constants/strings.dart';

class Destination {
  const Destination({
    required this.iconPath,
    required this.label,
  });

  final String iconPath;
  final String label;
}

const destinations = [
  Destination(
    iconPath: IconsAssets.contacts,
    label: Strings.contacts,
  ),
  Destination(
    iconPath: IconsAssets.chats,
    label: Strings.chats,
  ),
  Destination(
    iconPath: IconsAssets.more,
    label: Strings.more,
  ),
];

class AppNavigationBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final List<Destination> navigationDestinations;

  const AppNavigationBar({
    super.key,
    required this.navigationShell,
    required this.navigationDestinations,
  });

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int _selectedIndex = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final String location = GoRouter.of(context).state!.path!;

    if (location.startsWith('/${RouteName.contacts}')) {
      _selectedIndex = 0;
    } else if (location.startsWith('/${RouteName.chats}')) {
      _selectedIndex = 1;
    } else if (location.startsWith('/${RouteName.more}')) {
      _selectedIndex = 2;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final iconColor =
        isLight ? AppColors.textPrimary : AppColors.textPrimaryDark;
    return NavigationBar(
      destinations: widget.navigationDestinations
          .map(
            (destination) => NavigationDestination(
              label: destination.label,
              icon: SvgPicture.asset(
                destination.iconPath,
                height: 32,
                width: 32,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
              // selectedIcon: SvgPicture.asset(
              //   destination.iconPath,
              //   height: 32,
              //   width: 32,
              //   colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              // ),
            ),
          )
          .toList(),
      selectedIndex: _selectedIndex,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: _onDestinationSelected,
    );
  }

  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}
